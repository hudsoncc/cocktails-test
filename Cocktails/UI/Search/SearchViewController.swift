//
//  SearchViewController.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    // MARK: Props (public)

    public var viewModel: SearchViewModel!
    public var isSearching: Bool = false

    // MARK: Props (private)

    private var ui: SearchViewUI!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        bindToModel()
    }
   
    private func loadUI() {
        ui = SearchViewUI(for: self)
        
        title = viewModel.strings.title
        
        ui.searchController.searchBar.placeholder = viewModel.strings.searchPlaceholder
        
        ui.configureSettingsMenu(
            title: viewModel.strings.settings,
            actions: viewModel.settingsMenuActions
        )
    }
    
    private func bindToModel() {
        viewModel.$drinks.sink(receiveValue: { _ in
            DispatchQueue.main.async { [weak self] in
                self?.update()
            }
        })
        .store(in: &cancellables)
        
        viewModel.$searchResults.sink(receiveValue: { _ in
            DispatchQueue.main.async { [weak self] in
                self?.update()
            }
        })
        .store(in: &cancellables)
        
        viewModel.$fetchedImageAvailableForDrink.sink(receiveValue: { drink in
            DispatchQueue.main.async { [weak self] in
                self?.updateCellImage(forDrink: drink)
            }
        })
        .store(in: &cancellables)
    }

    private func update() {
        UIView.transition(with: ui.tableView, duration: 0.25, options: .transitionCrossDissolve) {
            self.ui.tableView.reloadData()
        }
        
        ui.showEmptyDataSetView(show: viewModel.hasDrinks(isSearching: self.isSearching))

        updateStrings()
    }
    
    private func updateStrings() {
        if isSearching {
            let content = viewModel.contentForCurrentSearchState()
            ui.emptyDataSetView.title = content.0
            ui.emptyDataSetView.detail = content.1
        }
        else {
            ui.emptyDataSetView.title = viewModel.strings.emptyDataSetTitle
            ui.emptyDataSetView.detail = viewModel.strings.emptyDataSetDetail
        }
    }
    
    private func updateEmptyDataSetForSearchTransition() {
        ui.transitionEmptyDataSetView(isSearching: isSearching) { [weak self] in
            self?.ui.tableView.reloadSectionIndexTitles()
        }
        updateStrings()
    }
   
    private func updateCellImage(forDrink drink: SearchViewDataItem?) {
        guard
            let drink = drink,
            let indexPathToUpdate = viewModel.indexPath(forDrink: drink, isSearching: isSearching),
            let cellToUpdate = ui.tableView.cellForRow(at: indexPathToUpdate) as? SearchViewCell else {
            return
        }
        cellToUpdate.configure(forImageData: drink.thumbData)
    }
    
    // MARK: Actions

    public func settingsMenuActionWasPressed(_ actionTitle: String) {
        let action = SearchViewModel.SettingsMenuAction.allCases.first(where: {
            $0.title == actionTitle
        })
        viewModel.performSettings(action: action!)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections(isSearching: isSearching)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let titles = viewModel.sectionIndexTitles(isSearching: isSearching)
        return ui.isTransitioning ? [] : titles
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeader(at: section, isSearching: isSearching)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.drinksCount(for: section, isSearching: isSearching)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.cellID, for: indexPath) as! SearchViewCell
        
        if let drink = viewModel.drink(at: indexPath, isSearching: isSearching) {
            cell.configure(for: drink)
        }        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let drink = viewModel.drink(at: indexPath, isSearching: isSearching) else {
            return
        }
        viewModel.showDetails(forDrink: drink)
    }
}

extension SearchViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        isSearching = true
        ui.fadeTableViewOutIn()
        updateEmptyDataSetForSearchTransition()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearching = false
        ui.fadeTableViewOutIn()
        updateEmptyDataSetForSearchTransition()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        update()
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else {
            return
        }
        
        viewModel.fetchDrinksDebounced(forSearchQuery: searchQuery)
    }
    
}


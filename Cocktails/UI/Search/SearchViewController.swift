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

    // MARK: Props (private)

    private var ui: SearchViewUI!
    private var cancellables: Set<AnyCancellable> = []
    private var isSearching: Bool { ui.searchController.isActive }
    
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
    }

    private func update() {
        ui.tableView.reloadData()
        ui.emptyDataSetView.isHidden = viewModel.hasDrinks(isSearching: isSearching)
        
        updateStrings()
    }
    
    private func updateStrings() {
        if isSearching {
            ui.emptyDataSetView.title = viewModel.strings.emptySearchTitle
            ui.emptyDataSetView.detail = viewModel.strings.emptySearchDetail
        } else {
            ui.emptyDataSetView.title = viewModel.strings.emptyDataSetTitle
            ui.emptyDataSetView.detail = viewModel.strings.emptyDataSetDetail
        }
    }
   
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.drinksCount(isSearching: isSearching)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.cellID, for: indexPath) as! SearchViewCell
        
        let drink = viewModel.drink(at: indexPath.row, isSearching: isSearching)
        cell.configure(for: drink)
        
        return cell
    }
    
    
}

extension SearchViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        update()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        update()
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else {
            return
        }
        
        viewModel.fetchDrinksDebounced(for: searchQuery)
    }
    
}


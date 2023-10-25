//
//  SearchUI.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import UIKit

class SearchViewUI: NSObject {
    
    struct Metric {
        static let estimatedRowHeight: CGFloat = 44
    }
    
    // MARK: Props (public)
    
    private(set) var searchController = UISearchController(searchResultsController: nil)
    private(set) var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private(set) var emptyDataSetView = EmptyDatasetView()
    private(set) var settingsButton = UIBarButtonItem(symbol: "ellipsis.circle")
    public var isTransitioning: Bool = false

    // MARK: Props (private)
    
    private var view: UIView { viewController.view }
    private var viewController: SearchViewController!
    public var navigationBar: UINavigationBar {
        viewController.navigationController!.navigationBar
    }
    
    private var emptyDataSetViewCenter: NSLayoutConstraint!

    // MARK: Life cycle
    
    convenience init(for viewController: SearchViewController) {
        self.init()
        
        self.viewController = viewController
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationBar.prefersLargeTitles = true
        
        addSettingsButton()
        addSearchController()
        addTableView()
        addEmptyDatasetView()
    }
    
    // MARK: Configuration
    
    public func configureSettingsMenu(title: String, actions: [String]) {
        var menuActions = [UIAction]()
        
        actions.forEach {
            menuActions.append(newAction(title: $0))
        }
        
        func newAction(title: String) -> UIAction {
            let action = UIAction(title: title, image: nil, handler: { [unowned self] action in
                viewController.settingsMenuActionWasPressed(action.title)
            })
            return action
        }
        
        let menu = UIMenu(title: title, options: .displayInline, children: menuActions)
        settingsButton.menu = menu
    }
    
    // MARK: Subviews
    
    private func addSettingsButton() {
        viewController.navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func addTableView() {
        tableView.dataSource = viewController
        tableView.delegate = viewController
        tableView.estimatedRowHeight = Metric.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.alwaysBounceVertical = true
        tableView.registerCells([SearchViewCell.self])
        view.addSubview(tableView)
        tableView.anchorFill()
    }
    
    private func addSearchController() {
        searchController.searchResultsUpdater = viewController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = viewController
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addEmptyDatasetView() {
        emptyDataSetView.backgroundColor = .systemGroupedBackground
        emptyDataSetView.symbol = "wineglass"
        view.addSubview(emptyDataSetView)
        emptyDataSetView.anchorFillHorizontally()
        emptyDataSetView.anchorToHeight()
        emptyDataSetViewCenter = emptyDataSetView.anchorCenterY()
    }
    
    // MARK: View transitions
    
    public func fadeTableViewOutIn() {
        let tableView = self.tableView
        let duration = 0.2
        UIView.animate(withDuration: duration) { tableView.alpha = 0 } completion: {_ in
            UIView.animate(withDuration: duration) { tableView.alpha = 1 }
        }
    }
    
    public func showEmptyDataSetView(show: Bool) {
        UIView.transition(with: emptyDataSetView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.emptyDataSetView.isHidden = show
        }
    }
    
    public func transitionEmptyDataSetView(isSearching: Bool, completion: @escaping ()->()) {
        isTransitioning = true
        emptyDataSetViewCenter.constant = isSearching ? -88 : 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] isFinished in
            if isFinished {
                self?.isTransitioning = false
                completion()
            }
        }
    }
    
}

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

    // MARK: Props (private)
    
    private var view: UIView { viewController.view }
    private var viewController: SearchViewController!
    public var navigationBar: UINavigationBar {
        viewController.navigationController!.navigationBar
    }
    
    // MARK: Life cycle
    
    convenience init(for viewController: SearchViewController) {
        self.init()
        
        self.viewController = viewController
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationBar.prefersLargeTitles = true
        
        addSearchController()
        addTableView()
        addEmptyDatasetView()
    }
    
    // MARK: Subviews
    
    private func addTableView() {
        tableView.dataSource = viewController
        tableView.delegate = viewController
        tableView.estimatedRowHeight = Metric.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCells([SearchViewCell.self])
        view.addSubview(tableView)
        tableView.anchorFill()
    }
    
    private func addSearchController() {
        searchController.searchResultsUpdater = viewController
        searchController.obscuresBackgroundDuringPresentation = false
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addEmptyDatasetView() {
        emptyDataSetView.symbol = "wineglass"
        view.addSubview(emptyDataSetView)
        emptyDataSetView.anchorFill()
    }
    
}

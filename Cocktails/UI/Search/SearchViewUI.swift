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
    private(set) var tableView = UITableView(frame: .zero, style: .plain)
    private(set) var emptyDataSetView = EmptyDatasetView()

    // MARK: Props (private)
    
    private var view: UIView { viewController.view }
    private var viewController: SearchViewController!

    // MARK: Life cycle
    
    convenience init(for viewController: SearchViewController) {
        self.init()
        
        self.viewController = viewController
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        addSearchController()
        addTableView()
        addEmptyDatasetView()
    }
    
    // MARK: Subviews
    
    private func addTableView() {
        tableView.estimatedRowHeight = Metric.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        tableView.anchorFill()
    }
    
    private func addSearchController() {
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

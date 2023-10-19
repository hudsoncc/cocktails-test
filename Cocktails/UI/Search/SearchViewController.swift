//
//  SearchViewController.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: Props (public)

    public var viewModel: SearchViewModel!

    // MARK: Props (private)

    private var ui: SearchViewUI!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
   
    private func loadUI() {
        ui = SearchViewUI(for: self)
        
        title = viewModel.strings.title
        
        ui.searchController.searchBar.placeholder = viewModel.strings.searchPlaceholder
        ui.emptyDataSetView.title = viewModel.strings.emptyDataSetTitle
        ui.emptyDataSetView.detail = viewModel.strings.emptyDataSetDetail
    }

}


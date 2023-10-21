//
//  DetailViewUI.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import UIKit

class DetailViewUI: NSObject {
    
    // MARK: Enums
    
    enum Section: Int, CaseIterable {
        case tags
        case ingredients
        case instructions
        
        static var count: Int {
            allCases.count
        }
    }

    // MARK: Structs
    
    struct Metric {
        static let estimatedRowHeight: CGFloat = 88
    }
    
    // MARK: Props (public)

    private(set) var tableView = UITableView(frame: .zero, style: .plain)

    // MARK: Props (private)
    
    private var view: UIView { viewController.view }
    private var viewController: DetailViewController!
    
    // MARK: Life cycle
    
    convenience init(for viewController: DetailViewController) {
        self.init()
        
        self.viewController = viewController
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        addTableView()
    
    // MARK: Subviews
    
    private func addTableView() {
        tableView.dataSource = viewController
        tableView.estimatedRowHeight = Metric.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCells([UITableViewCell.self])
        view.addSubview(tableView)
        tableView.anchorFill()
    }
    
    }
    
}
    


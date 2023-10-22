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
        case ingredients
        case instructions
        
        static var count: Int {
            allCases.count
        }
    }

    // MARK: Structs
    
    struct Metric {
        static let headerViewHeight: CGFloat = 384
        static let estimatedRowHeight: CGFloat = 88
    }
    
    // MARK: Props (public)

    private(set) var tableView = UITableView(frame: .zero, style: .plain)
    private(set) var headerView = DetailHeaderView()
    
    lazy public var videoButton: UIBarButtonItem = {
        addVideoButtonIfNeeded()
    }()

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
        addHeaderView()
        addBackButton()
    }
    
    private func addBackButton() {
        let action = #selector(viewController.goBack)
        let buttonItem = VibrancyBarButtonItem(
            symbol: "chevron.backward", target: viewController, action: action
        )
        viewController.navigationItem.leftBarButtonItem = buttonItem
    }
    
    private func addVideoButtonIfNeeded() -> UIBarButtonItem {
        let action = #selector(viewController.openVideoInBrowser)
        videoButton = VibrancyBarButtonItem(
            symbol: "play.fill", target: viewController, action: action
        )
        viewController.navigationItem.setRightBarButton(videoButton, animated: true)
        return videoButton
    }
    
    // MARK: Subviews
    
    private func addTableView() {
        tableView.dataSource = viewController
        tableView.delegate = viewController
        tableView.estimatedRowHeight = Metric.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.registerCells([DetailViewCell.self])
        view.addSubview(tableView)
        tableView.anchorFill()
    }
    
    private func addHeaderView() {
        tableView.tableHeaderView = headerView
        tableView.contentInsetAdjustmentBehavior = .never

        headerView.anchorToWidth(ofView: tableView)
        headerView.anchorEdges([.top, .left, .right])
        headerView.anchorHeight(Metric.headerViewHeight)
    }
    
}
    


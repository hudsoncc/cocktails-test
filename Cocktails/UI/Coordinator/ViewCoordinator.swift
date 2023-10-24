//
//  ViewCoordinator.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation
import UIKit

class ViewCoordinator: NSObject {
    
    // MARK: Props (public)

    private(set) var navigationController: UINavigationController!
    private(set) var window: UIWindow!

    // MARK: Life cycle
    
    init(window: UIWindow, navigationController: UINavigationController? = nil) {
        self.window = window
        self.navigationController = navigationController ?? UINavigationController()
        
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
    }

    // MARK: API (public)

    public func start() {
        let viewModel = SearchViewModel(coordinator: self)
        let viewController = SearchViewController()
        viewController.viewModel = viewModel
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    public func navigateBack() {
        navigationController.popViewController(animated: true)
    }
    
    public func navigateToDetails(forDrinkID drinkID: String) {
        let viewModel = DetailViewModel(drinkID: drinkID, coordinator: self)
        let viewController = DetailViewController()
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}

//
//  SceneDelegate.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: Props (public)

    var window: UIWindow?
    private var viewCoordinator: ViewCoordinator?

    // MARK: Life cycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        Task {
            do {
                try await LocalData.shared.load()
                addWindow(to: windowScene)
            }
            catch {
                // Error handling out of scope for project?
            }
        }
        
    }

    // MARK: Setup
    
    private func addWindow(to scene: UIWindowScene) {
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        addViewCoordinator(for: window)
        
        UIControl.appearance().tintColor = .label
        UIView.appearance().tintColor = .label
    }
    
    private func addViewCoordinator(for window: UIWindow?) {
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        viewCoordinator = ViewCoordinator(navigationController: navigationController)
        viewCoordinator?.start()
    }

}


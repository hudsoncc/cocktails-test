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
    public var viewController: ViewController!

    // MARK: Life cycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        addWindow(to: windowScene)
    }

    // MARK: Setup
    
    private func addWindow(to scene: UIWindowScene) {
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        addViewController(to: window)
    }
    
    private func addViewController(to window: UIWindow?) {
        viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}


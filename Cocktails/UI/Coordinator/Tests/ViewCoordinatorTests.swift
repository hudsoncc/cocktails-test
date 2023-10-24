//
//  ViewCoordinatorTests.swift
//  CocktailsTests
//
//  Created by Hudson Maul on 24/10/2023.
//

import XCTest
 
final class ViewCoordinatorTests: XCTestCase {

    var coordinator: ViewCoordinator!
    var window: UIWindow!
    var navigationController: MockNavigationController!

    override func setUpWithError() throws {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = MockNavigationController()
        coordinator = ViewCoordinator(window: window, navigationController: navigationController)
    }

    override func tearDownWithError() throws {
        window = nil
        navigationController = nil
        coordinator = nil
    }

    func test_init_makes_sceneWindowKey() throws {
        XCTAssertTrue(coordinator.window.isKeyWindow)
    }
    
    func test_init_sets_windowRootViewController() throws {
        XCTAssertEqual(coordinator.window.rootViewController, navigationController)
    }

    @MainActor
    func test_start_presents_searchViewController() async throws {
        try await LocalData.shared.load(inMemory: true)
        coordinator.start()
        XCTAssertTrue(navigationController.topViewController! is SearchViewController)
        XCTAssertNotNil(navigationController.topViewController!.isBeingPresented)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
    @MainActor
    func test_navigateToDetails_pushes_detailViewController() async throws {
        try await LocalData.shared.load(inMemory: true)
        coordinator.start()
        coordinator.navigateToDetails(forDrinkID: "")
        XCTAssertTrue(navigationController.topViewController! is DetailViewController)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }
    
    @MainActor
    func test_navigateBack_returns_previousViewController() async throws {
        try await LocalData.shared.load(inMemory: true)
        coordinator.start()
        let firstVC = coordinator.navigationController.topViewController!
        navigationController.pushViewController(UIViewController(), animated: false)
        coordinator.navigateBack()
        XCTAssertEqual(navigationController.topViewController, firstVC)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
 
}

class MockNavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: false)
    }
}

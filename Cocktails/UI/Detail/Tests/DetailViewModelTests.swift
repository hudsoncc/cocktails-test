//
//  DetailViewModelTests.swift
//  CocktailsTests
//
//  Created by Hudson Maul on 25/10/2023.
//

import XCTest

final class DetailViewModelTests: XCTestCase {

    var coordinator: ViewCoordinator!
    var window: UIWindow!
    var navigationController: MockNavigationController!
    var mockImageLoader: MockImageLoader!
    var localData: LocalData { LocalData.shared }
    
    override func setUpWithError() throws {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = MockNavigationController()
        mockImageLoader = MockImageLoader()
        coordinator = ViewCoordinator(window: window, navigationController: navigationController)
    }
    
    override func tearDownWithError() throws {
        window = nil
        navigationController = nil
        coordinator = nil
        mockImageLoader.clearCache()
        mockImageLoader = nil
        localData.coreData.destroyStore()
    }
    
    func test_init_fetchesDrink_forPassedInID() async throws {
        let viewModel = try await newViewModel(cachedDrink: .init(idDrink: "foo", strDrink: "foo"))
        XCTAssertEqual(viewModel.drink?.name, "foo")
    }

    func test_fetchDrinkWithID_whenFetched_canLoadTheDrinksImage() async throws {
        let imageURL = URL(string: "https://test.com/aDrink.png")!
        let drink = API.Model.Drink(
            idDrink: "foo", strDrink: "foo", strDrinkThumb: imageURL.absoluteString
        )
        
        XCTAssertNil(mockImageLoader.loadImage(forURL: imageURL))

        let viewModel = try await newViewModel(cachedDrink: drink)
        
        await waitAsync(description: "wait for image data loaded/fetched async", timeOut: 1.5) {
            XCTAssertNotNil(viewModel.drinkImageData)
            XCTAssertNotNil(self.mockImageLoader.loadImage(forURL: imageURL))
        }
    }
    
    @MainActor
    func test_fetchDrinkWithID_whenNotFound_navigatesBack() async throws {
        try await localData.load(inMemory: true)
        let nc = navigationController!
        nc.pushViewController(UIViewController(), animated: false)
        XCTAssertEqual(nc.viewControllers.count, 1)
        coordinator.navigateToDetails(forDrinkID: "id for drink that doesn't exist")
        await waitAsync(description: "wait for image data loaded/fetched async", timeOut: 1.5) {
            XCTAssertEqual(self.navigationController.viewControllers.count, 1)
        }
    }
        
    // MARK: Helpers
    
    private func newViewModel(cachedDrink: API.Model.Drink) async throws -> DetailViewModel {
        try await localData.load(inMemory: true)
        localData.saveDrinks(from: [cachedDrink.dictionaryRepresentation()])
        return DetailViewModel(
            drinkID: cachedDrink.idDrink,
            coordinator: coordinator,
            imageLoader: mockImageLoader
        )
    }
}

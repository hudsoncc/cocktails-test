//
//  SearchViewModelTests.swift
//  CocktailsTests
//
//  Created by Hudson Maul on 24/10/2023.
//

import XCTest

final class SearchViewModelTests: XCTestCase {

    var coordinator: ViewCoordinator!
    var window: UIWindow!
    var navigationController: MockNavigationController!
    var mockAPI: APIService!
    var mockImageLoader: MockImageLoader!
    var localData: LocalData { LocalData.shared }

    override func setUpWithError() throws {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = MockNavigationController()
        mockAPI = MockAPI()
        mockImageLoader = MockImageLoader()
        coordinator = ViewCoordinator(window: window, navigationController: navigationController)
    }
    
    override func tearDownWithError() throws {
        window = nil
        navigationController = nil
        coordinator = nil
        mockAPI = nil
        mockImageLoader.clearCache()
        mockImageLoader = nil
        localData.coreData.destroyStore()
    }
    
    func test_init_fetchesAllDrinks() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a")
        ])
        XCTAssertEqual(viewModel.drinks.count, 1)
    }
    
    func test_fetchesAllDrinks_whenDrinkStartsWithLetter_groupsByFirstLetter() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "foo"),
            .init(idDrink: "", strDrink: "bar")
        ])
        XCTAssertEqual(viewModel.groupedDrinks["F"]!.count, 1)
        XCTAssertEqual(viewModel.groupedDrinks["B"]!.count, 1)
        XCTAssertEqual(viewModel.sectionIndexTitles, ["B", "F"])
    }
    
    func test_fetchesAllDrinks_whenDrinkStartsWithNumber_groupsByHashCharacter() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "1"),
            .init(idDrink: "", strDrink: "3")
        ])
        XCTAssertEqual(viewModel.sectionIndexTitles, ["#"])
        XCTAssertEqual(viewModel.groupedDrinks["#"]!.count, 2)
    }
    
    func test_fetchesAllDrinks_generatesSectionIndexTitles() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "foo"),
            .init(idDrink: "", strDrink: "123foo")
        ])
        XCTAssertEqual(viewModel.sectionIndexTitles, ["F", "#"])
    }
    
    func test_drinkAtIndexPath_whenNoDrinksAreCached_returnsNil() async throws {
        let viewModel = try await newViewModel()
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertNil(viewModel.drink(at: indexPath, isSearching: false))
        XCTAssertNil(viewModel.drink(at: indexPath, isSearching: true))
    }
    
    func test_drinkAtIndexPath_whenNotSearching_returnsDrinkForIndexPath() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "ab"),
            .init(idDrink: "", strDrink: "b")
        ])
        
        let isSearching = false
        var drink = viewModel.drink(at: IndexPath(row: 0, section: 0), isSearching: isSearching)
        XCTAssertEqual(drink?.name, "a")
        drink = viewModel.drink(at: IndexPath(row: 1, section: 0), isSearching: isSearching)
        XCTAssertEqual(drink?.name, "ab")
        drink = viewModel.drink(at: IndexPath(row: 0, section: 1), isSearching: isSearching)
        XCTAssertEqual(drink?.name, "b")
    }
    
    func test_drinkAtIndexPath_whenSearching_returnsDrinkForIndexPath() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "ab"),
            .init(idDrink: "", strDrink: "b")
        ])
        
        let isSearching = true
        viewModel.fetchDrinksLocally(forSearchQuery: "a")
        var drink = viewModel.drink(at: IndexPath(row: 0, section: 0), isSearching: isSearching)
        XCTAssertEqual(drink?.name, "a")
        drink = viewModel.drink(at: IndexPath(row: 1, section: 0), isSearching: isSearching)
        XCTAssertEqual(drink?.name, "ab")
    }
    
    func test_indexPathForDrink_whenNoDrinksAreCached_returnsNil() async throws {
        let viewModel = try await newViewModel()
        let drinkA = API.Model.Drink(idDrink: "", strDrink: "a")
        // Save a drink directly to the store, so we don't automatically fetch the drink in
        // the view model via the view model's own `saveDrinks` method.
        localData.saveDrinks(from: [drinkA.dictionaryRepresentation()])
        let fetchedDrinkItems = localData.fetchDrinks().map { SearchViewDataItem(drink: $0) }
        XCTAssertNil(viewModel.indexPath(forDrink: fetchedDrinkItems.first!, isSearching: false))
        XCTAssertNil(viewModel.indexPath(forDrink: fetchedDrinkItems.first!, isSearching: true))
    }
    
    func test_indexPathForDrink_whenNotSearching_returnsIndexPathForDrink() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "a", strDrink: "a"),
            .init(idDrink: "b", strDrink: "ab"),
            .init(idDrink: "c", strDrink: "c")
        ])
        let drinkAItem = viewModel.drinks.filter { $0.name == "a" }.first!
        let drinkABItem = viewModel.drinks.filter { $0.name == "ab" }.first!
        let drinkCItem = viewModel.drinks.filter { $0.name == "c" }.first!
        let isSearching = false
        
        var indexPath = viewModel.indexPath(forDrink: drinkAItem, isSearching: isSearching)
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
        indexPath = viewModel.indexPath(forDrink: drinkABItem, isSearching: isSearching)
        XCTAssertEqual(indexPath, IndexPath(row: 1, section: 0))
        indexPath = viewModel.indexPath(forDrink: drinkCItem, isSearching: isSearching)
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 1))
    }
    
    func test_indexPathForDrink_whenSearching_returnsIndexPathForDrink() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "a", strDrink: "a"),
            .init(idDrink: "b", strDrink: "ab"),
        ])
        let drinkAItem = viewModel.drinks.filter { $0.id == "a" }.first!
        let drinkABItem = viewModel.drinks.filter { $0.id == "b" }.first!
        let isSearching = true
        
        viewModel.fetchDrinksLocally(forSearchQuery: "a")
        var indexPath = viewModel.indexPath(forDrink: drinkAItem, isSearching: isSearching)
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
        indexPath = viewModel.indexPath(forDrink: drinkABItem, isSearching: isSearching)
        XCTAssertEqual(indexPath, IndexPath(row: 1, section: 0))
    }
 
    func test_saveDrinks_persistsThenFetchesSavedDrinks() async throws {
        let viewModel = try await newViewModel()
        XCTAssertEqual(viewModel.drinks.count, 0)
        viewModel.saveDrinks(API.Model.Drinks(drinks: [
            API.Model.Drink(idDrink: "", strDrink: "a"),
        ]))
        XCTAssertEqual(viewModel.drinks.count, 1)
    }

    func test_titleForHeaderAt_whenSearching_returnsNil() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
        ])
        
        viewModel.fetchDrinksLocally(forSearchQuery: "a")
        XCTAssertNil(viewModel.titleForHeader(at: 0, isSearching: true))
    }
    
    func test_titleForHeaderAt_whenNotSearching_returnsTitleForSection() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "b"),
            .init(idDrink: "", strDrink: "c")
        ])
        XCTAssertEqual(viewModel.sectionIndexTitles.count, 3)
        XCTAssertEqual(viewModel.sectionIndexTitles, ["A", "B", "C"])
        XCTAssertEqual(viewModel.titleForHeader(at: 0, isSearching: false), "A")
        XCTAssertEqual(viewModel.titleForHeader(at: 1, isSearching: false), "B")
        XCTAssertEqual(viewModel.titleForHeader(at: 2, isSearching: false), "C")
    }
    
    func test_sectionTitleForDrink_returnsTheDrinksFirstLetterOrNumber() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "1"),
        ])
        let drinkAItem = viewModel.drinks.filter { $0.name == "a" }.first!
        let drink1Item = viewModel.drinks.filter { $0.name == "1" }.first!
        XCTAssertEqual(viewModel.sectionTitle(forDrink: drinkAItem), "A")
        XCTAssertEqual(viewModel.sectionTitle(forDrink: drink1Item), "#")
    }
    
    func test_numberOfSections_whenNotSearching_returnsTheCorrectCount() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "b"),
            .init(idDrink: "", strDrink: "c")
        ])
        XCTAssertEqual(viewModel.numberOfSections(isSearching: false), 3)
    }
    
    func test_numberOfSections_whenSearching_returns1() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "b"),
            .init(idDrink: "", strDrink: "c")
        ])
        XCTAssertEqual(viewModel.numberOfSections(isSearching: true), 1)
    }
    
    func test_drinksCountForSection_returnsCorrectCount() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "b"),
            .init(idDrink: "", strDrink: "b")
        ])
        XCTAssertEqual(viewModel.drinksCount(for: 0, isSearching: false), 1)
        XCTAssertEqual(viewModel.drinksCount(for: 1, isSearching: false), 2)
        
        viewModel.fetchDrinksLocally(forSearchQuery: "b")
        XCTAssertEqual(viewModel.drinksCount(for: 0, isSearching: true), 2)
    }
    
    func test_hasDrinks_whenNoDrinksAreCached_returnsFalse() async throws {
        let viewModel = try await newViewModel()
        XCTAssertFalse(viewModel.hasDrinks(isSearching: false))
        XCTAssertFalse(viewModel.hasDrinks(isSearching: true))
    }
    
    func test_hasDrinks_whenDrinksAreCachedAndNotSearching_returnsTrue() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a")
        ])
        XCTAssertTrue(viewModel.hasDrinks(isSearching: false))
    }
    
    func test_hasDrinks_whenSearchHasMatches_returnsTrue() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a")
        ])
        viewModel.fetchDrinksLocally(forSearchQuery: "a")
        XCTAssertTrue(viewModel.hasDrinks(isSearching: true))
    }
    
    func test_hasDrinks_whenSearchHasNoMatches_returnsFalse() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a")
        ])
        viewModel.fetchDrinksLocally(forSearchQuery: "b")
        XCTAssertFalse(viewModel.hasDrinks(isSearching: true))
    }
    
    @MainActor
    func test_showDetailsForDrink_showsTheCorrectDrinksDetails() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "foo", strTags: "hello")
        ])
        viewModel.showDetails(forDrink: viewModel.drinks.first!)
        let detailVC = navigationController.topViewController as? DetailViewController
        XCTAssertNotNil(detailVC)
        
        await waitAsync(description: "wait for view model to fetch the drink", timeOut: 1.5) {
            XCTAssertEqual(detailVC?.viewModel.drink?.name, "foo")
        }
    }
    
    func test_resetDrinkData_deletesAllCachedDrinks() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "b")
        ])
        viewModel.performSettings(action: .resetDrinkData)
        XCTAssertTrue(viewModel.drinks.isEmpty)
    }
    
    func test_resetImageCache_deletesAllCachedImages() async throws {
        let viewModel = try await newViewModel()
        let imageURL = URL(string: "https://test.com/aDrink.png")!
        _ = try await mockImageLoader.fetchImage(forURL: imageURL)
        XCTAssertNotNil(mockImageLoader.loadImage(forURL: imageURL))
        
        viewModel.performSettings(action: .resetImageCache)
        XCTAssertNil(mockImageLoader.loadImage(forURL: imageURL))
    }
    
    func test_resetAllData_deletesAllCachedDrinksAndImages() async throws {
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "", strDrink: "a"),
            .init(idDrink: "", strDrink: "b")
        ])
        
        let imageURL = URL(string: "https://test.com/aDrink.png")!
        _ = try await mockImageLoader.fetchImage(forURL: imageURL)
        XCTAssertNotNil(mockImageLoader.loadImage(forURL: imageURL))

        viewModel.performSettings(action: .resetAllData)
        XCTAssertTrue(viewModel.drinks.isEmpty)
        XCTAssertNil(mockImageLoader.loadImage(forURL: imageURL))
    }
    
    func test_loadOrFetchImageIfNeeded_ifNotCached_fetchesTheImage() async throws {
        let imageURL = URL(string: "https://test.com/aDrink.png")!
        let viewModel = try await newViewModel(cachedDrinks: [
            .init(idDrink: "a", strDrink: "a", strDrinkThumb: imageURL.absoluteString)
        ])
        XCTAssertNil(mockImageLoader.loadImage(forURL: imageURL))
        
        let drink = viewModel.drinks.first!
        XCTAssertEqual(drink.thumbURL, imageURL)
        XCTAssertNil(drink.thumbData)

        await viewModel.loadOrFetchImageIfNeeded(forDrink: drink)
        XCTAssertEqual(viewModel.fetchedImageAvailableForDrink!.thumbURL, imageURL)
        XCTAssertNotNil(mockImageLoader.loadImage(forURL: imageURL))
    }
    
    // MARK: Helpers
    
    private func newViewModel(cachedDrinks: [API.Model.Drink] = []) async throws -> SearchViewModel {
        try await localData.load(inMemory: true)
        if !cachedDrinks.isEmpty {
            localData.saveDrinks(from: cachedDrinks.map { $0.dictionaryRepresentation() })
        }
        return SearchViewModel(coordinator: coordinator, api: mockAPI, imageLoader: mockImageLoader)
    }
    
}

private class MockAPI: APIService {
    
    func fetchDrinks(forQuery searchQuery: String) async throws -> API.Model.Drinks {
        API.Model.Drinks(drinks: [
            API.Model.Drink(idDrink: UUID().uuidString, strDrink: "foo"),
            API.Model.Drink(idDrink: UUID().uuidString, strDrink: "123 foo")
        ])
    }
    
    func enqueueRequest<T>(_ request: URLRequest) async throws -> T where T : Decodable {
        return API.Model.Drinks() as! T
    }
    
    func newRequest(_ method: API.HTTPMethod, toEndpoint endpoint: API.Endpoint, params: [URLQueryItem]) -> URLRequest {
        return URLRequest(url: URL(string: "http://www.apple.com")!)
    }
        
}

class MockImageLoader: ImageLoadable {
    
    public var cachePath: String { "testImageCache" }

    func fetchImage(forURL url: URL) async throws -> Data? {
        let fetchedImageData = UIImage(systemName: "pencil")!.pngData()!
        let fileName = imagePathForCachedImage(withURL: url)
        createCacheDirectoryIfNeeded()
        try? fetchedImageData.write(to: fileName)
        return fetchedImageData
    }
}

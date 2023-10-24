//
//  SearchViewModel.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

class SearchViewModel: ViewModel {
   
    // Enums
    
    struct Metric {
        static let userInputDebounceInterval: TimeInterval = 0.5
    }
    
    // MARK: Props (public)
    
    public let strings = Strings.SearchView()
    @Published public var drinks = [SearchViewDataItem]()
    @Published public var searchResults = [SearchViewDataItem]()
    @Published public var fetchedImageAvailableForDrink: SearchViewDataItem?
    public var sectionIndexTitles = [String]()
    public var groupedDrinks = [String: [SearchViewDataItem]]()

    // MARK: Props (private)
    
    private var currentSearchQuery: String?
    private var api = API()
    private var imageLoader = WebImageLoader()

    override init(coordinator: ViewCoordinator) {
        super.init(coordinator: coordinator)
        fetchAllDrinks()
    }
    
    // MARK: Data
    
    public func drink(at indexPath: IndexPath, isSearching: Bool) -> SearchViewDataItem? {
        var drink: SearchViewDataItem?
        
        if isSearching {
            drink = indexPath.row < searchResults.count ? searchResults[indexPath.row] : nil
        }
        else {
            let sectionTitle = sectionIndexTitles[indexPath.section]
            guard let drinksForSection = groupedDrinks[sectionTitle] else { return nil }
            drink = indexPath.row < drinksForSection.count ? drinksForSection[indexPath.row] : nil
        }
        
        loadOrFetchImageIfNeeded(forDrink: drink)
        
        return drink
    }
    
    public func indexPath(forDrink drink: SearchViewDataItem, isSearching: Bool) -> IndexPath? {
        if isSearching {
            if let drinkIndex = searchResults.firstIndex(where: { $0.id == drink.id }) {
                return IndexPath(row: drinkIndex, section: 0)
            }
        }
  
        let sectionKey = sectionTitle(forDrink: drink)
        if let drinkSection = Array(groupedDrinks.keys).firstIndex(of: sectionKey),
           let drinkIndex = groupedDrinks[sectionKey]?.firstIndex(where: { $0.id == drink.id } ) {
            return IndexPath(row: drinkIndex, section: drinkSection)
        }
        return nil
    }
    
    public func titleForHeader(at section: Int, isSearching: Bool) -> String? {
        isSearching ? nil : sectionIndexTitles[section]
    }
    
    public func sectionIndexTitles(isSearching: Bool) -> [String]? {
        isSearching ? nil : sectionIndexTitles
    }
    
    public func sectionTitle(forDrink drink: SearchViewDataItem) -> String {
        drink.name.prefix(1).uppercased()
    }
    
    public func numberOfSections(isSearching: Bool) -> Int {
        isSearching ? 1 : sectionIndexTitles.count
    }
    
    public func drinksCount(for section: Int, isSearching: Bool) -> Int {
        if isSearching {
            return searchResults.count
        }
        let sectionTitle = sectionIndexTitles[section]
        guard let drinksForSection = groupedDrinks[sectionTitle] else { return 0 }
        return drinksForSection.count
    }
    
    public func hasDrinks(isSearching: Bool) -> Bool {
        isSearching ? !searchResults.isEmpty : !drinks.isEmpty
    }
    
    public func searchResult(at index: Int) -> SearchViewDataItem {
        searchResults[index]
    }

    // MARK: Fetch
    
    public func fetchDrinksLocally(for searchQuery: String) {
        let drinks = LocalData.shared.fetchDrinks().map { SearchViewDataItem(drink: $0) }
        let searchFilter = SmartSearchFilter(searchQuery: searchQuery)
        let searchResults = drinks.filter { searchFilter.isMatch(for: $0.name) }
        self.searchResults = searchResults
    }
    
    public func fetchAllDrinks() {
        let data = LocalData.shared.fetchDrinks()
        let drinks = data.map { SearchViewDataItem(drink: $0) }
        groupedDrinks = Dictionary(grouping: drinks, by: { sectionTitle(forDrink: $0) })
        sectionIndexTitles = groupedDrinks.keys.sorted()
        
        self.drinks = drinks
    }
    
    public func fetchDrinksDebounced(for searchQuery: String) {
        currentSearchQuery = searchQuery
        
        let selector = #selector(fetchDrinksForSearchQuery)
        performDebounced(selector, afterDelay: Metric.userInputDebounceInterval)
    }

    @objc private func fetchDrinksForSearchQuery() {
        guard let searchQuery = currentSearchQuery else {
            searchResults = []
            return
        }
        
        Task {
            do {
                let drinks = try await api.fetchDrinks(forQuery: searchQuery)
                saveDrinks(drinks)
                fetchDrinksLocally(for: searchQuery)
            } catch {
                // Error handling out of scope for project?
            }
        }
    }
    
    private func saveDrinks(_ drinks: API.Model.Drinks) {
        let drinkDictionaries = drinks.drinks?.map { $0.dictionaryRepresentation() }
        LocalData.shared.saveDrinks(from: drinkDictionaries)
        fetchAllDrinks()
    }
    
    // MARK: Image Loading
    
    private func loadOrFetchImageIfNeeded(forDrink drink: SearchViewDataItem?) {
        guard let drink, let thumbURL = drink.thumbURL, drink.thumbData == nil else {
            return
        }
        
        guard let imageData = imageLoader.loadImage(forURL: thumbURL) else {
            fetchImage(forDrink: drink)
            return
        }
        
        drink.thumbData = imageData
    }
    
    private func fetchImage(forDrink drink: SearchViewDataItem) {
        Task {
            let url = drink.thumbURL!
            guard let imageData = try? await imageLoader.fetchImage(forURL: url) else {
                return
            }
            drink.thumbData = imageData
            fetchedImageAvailableForDrink = drink
        }
    }
    
    // MARK: Navigation
    
    public func showDetails(forDrink drink: SearchViewDataItem) {
        coordinator.navigateToDetails(forDrinkID: drink.id)
    }
}

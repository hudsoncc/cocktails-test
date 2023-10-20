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

    // MARK: Props (private)
    
    private var currentSearchQuery: String?
    private var api = API()

    override init(coordinator: ViewCoordinator) {
        super.init(coordinator: coordinator)
        fetchAllDrinks()
    }
    
    // MARK: Data
    
    public func drink(at index: Int, isSearching: Bool) -> SearchViewDataItem {
        isSearching ? searchResults[index] : drinks[index]
    }
    
    public func drinksCount(isSearching: Bool) -> Int {
        isSearching ? searchResults.count : drinks.count
    }
    
    public func hasDrinks(isSearching: Bool) -> Bool {
        isSearching ? !searchResults.isEmpty : !drinks.isEmpty
    }
    
    public func searchResult(at index: Int) -> SearchViewDataItem {
        searchResults[index]
    }

    // MARK: Fetch
    
    public func fetchDrinksLocally(for searchQuery: String) {
        let data = LocalData.shared.fetchDrinks(forQuery: searchQuery)
        searchResults = data.map { SearchViewDataItem(drink: $0) }
    }
    
    public func fetchAllDrinks() {
        let data = LocalData.shared.fetchDrinks()
        drinks = data.map { SearchViewDataItem(drink: $0) }
    }
    
    public func fetchDrinksDebounced(for searchQuery: String) {
        currentSearchQuery = searchQuery
        
        let selector = #selector(fetchDrinksForSearchQuery)
        performDebounced(selector, afterDelay: Metric.userInputDebounceInterval)
    }

    @objc private func fetchDrinksForSearchQuery() {
        guard let searchQuery = currentSearchQuery, !searchQuery.isEmpty else {
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
    }
    
    // MARK: Navigation
    
    public func showDetails(forDrink drink: SearchViewDataItem) {
        coordinator.navigateToDetails(forDrinkID: drink.id)
    }
}

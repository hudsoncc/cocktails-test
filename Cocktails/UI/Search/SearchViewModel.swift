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
    public var sectionIndexTitles = [String]()
    public var groupedDrinks = [String: [SearchViewDataItem]]()

    // MARK: Props (private)
    
    private var currentSearchQuery: String?
    private var api = API()

    override init(coordinator: ViewCoordinator) {
        super.init(coordinator: coordinator)
        fetchAllDrinks()
    }
    
    // MARK: Data
    
    public func drink(at indexPath: IndexPath, isSearching: Bool) -> SearchViewDataItem? {
        if isSearching {
            return indexPath.row < searchResults.count ? searchResults[indexPath.row] : nil
        }

        let sectionTitle = sectionIndexTitles[indexPath.section]
        guard let drinksForSection = groupedDrinks[sectionTitle] else { return nil }

        return indexPath.row < drinksForSection.count ? drinksForSection[indexPath.row] : nil
    }
    
    public func titleForHeader(at section: Int, isSearching: Bool) -> String? {
        isSearching ? nil : sectionIndexTitles[section]
    }
    
    public func sectionIndexTitles(isSearching: Bool) -> [String]? {
        isSearching ? nil : sectionIndexTitles
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
        let data = LocalData.shared.fetchDrinks(forQuery: searchQuery)
        searchResults = data.map { SearchViewDataItem(drink: $0) }
    }
    
    public func fetchAllDrinks() {
        let data = LocalData.shared.fetchDrinks()
        let drinks = data.map { SearchViewDataItem(drink: $0) }
        groupedDrinks = Dictionary(grouping: drinks, by: { $0.name.prefix(1).uppercased() })
        sectionIndexTitles = groupedDrinks.keys.sorted()
        
        self.drinks = drinks
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
        fetchAllDrinks()
    }
    
    // MARK: Navigation
    
    public func showDetails(forDrink drink: SearchViewDataItem) {
        coordinator.navigateToDetails(forDrinkID: drink.id)
    }
}

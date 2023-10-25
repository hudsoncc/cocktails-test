//
//  SearchViewModel.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

class SearchViewModel: ViewModel {
   
    // Enums

    enum SettingsMenuAction: String, CaseIterable {
        case resetImageCache
        case resetDrinkData
        case resetAllData
        
        var title: String {
            let strings = Strings.SearchView()
            return switch self {
            case .resetImageCache: strings.resetImageCache
            case .resetDrinkData: strings.resetDrinkData
            case .resetAllData: strings.resetAllData
            }
        }
        
        static var allTitles: [String] {
            allCases.map { $0.title }
        }
    }
    
    // Structs
    
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
    public var settingsMenuActions = SettingsMenuAction.allTitles

    // MARK: Props (private)
    
    private var currentSearchQuery: String?
    private var api: APIService!
    private var imageLoader: ImageLoadable!

    init(coordinator: ViewCoordinator, api: APIService, imageLoader: ImageLoadable? = nil) {
        super.init(coordinator: coordinator)
        self.api = api
        self.imageLoader = imageLoader ?? WebImageLoader()
        fetchAllDrinks()
    }
    
    // MARK: Data
    
    public func drink(at indexPath: IndexPath, isSearching: Bool) -> SearchViewDataItem? {
        var drink: SearchViewDataItem?
        
        if isSearching {
            drink = indexPath.row < searchResults.count ? searchResults[indexPath.row] : nil
        }
        else {
            guard indexPath.section < sectionIndexTitles.count else { return nil }
            let sectionTitle = sectionIndexTitles[indexPath.section]
            guard let drinksForSection = groupedDrinks[sectionTitle] else { return nil }
            drink = indexPath.row < drinksForSection.count ? drinksForSection[indexPath.row] : nil
        }
        
        if let drink {
            Task {
                await loadOrFetchImageIfNeeded(forDrink: drink)
            }
        }
        
        return drink
    }
    
    public func indexPath(forDrink drink: SearchViewDataItem, isSearching: Bool) -> IndexPath? {
        if isSearching {
            if let drinkIndex = searchResults.firstIndex(where: { $0.id == drink.id }) {
                return IndexPath(row: drinkIndex, section: 0)
            }
        }
  
        let sectionKey = sectionTitle(forDrink: drink)
        if let drinkSection = Array(groupedDrinks.keys.sorted()).firstIndex(of: sectionKey),
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
        let title = drink.name.prefix(1).uppercased()
        return title.isNumber ? strings.numericSectionIndexTitle : title
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
    
    private func generateIndexTitles(forGroup group: [String: [SearchViewDataItem]]) -> [String] {
        var indexTitles = groupedDrinks.keys.sorted()
        let numberIndexTitle = strings.numericSectionIndexTitle
        
        // Ensure the # section index is rendered last in the table view index.
        if indexTitles.contains(numberIndexTitle) {
            indexTitles = indexTitles.filter { $0 != numberIndexTitle }
            indexTitles.append(numberIndexTitle)
        }
        
        return indexTitles
    }

    // MARK: Fetch
    
    public func fetchDrinksLocally(forSearchQuery searchQuery: String) {
        let drinks = LocalData.shared.fetchDrinks().map { SearchViewDataItem(drink: $0) }
        let searchFilter = SmartSearchFilter(searchQuery: searchQuery)
        let searchResults = drinks.filter { searchFilter.isMatch(for: $0.name) }
        self.searchResults = searchResults
    }
    
    public func fetchAllDrinks() {
        let data = LocalData.shared.fetchDrinks()
        let drinks = data.map { SearchViewDataItem(drink: $0) }
        groupedDrinks = Dictionary(grouping: drinks, by: { sectionTitle(forDrink: $0) })
        self.sectionIndexTitles = generateIndexTitles(forGroup: groupedDrinks)
        self.drinks = drinks
    }
    
    public func fetchDrinksDebounced(forSearchQuery searchQuery: String) {
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
                if !searchQuery.isEmpty {
                    let drinks = try await api.fetchDrinks(forQuery: searchQuery)
                    saveDrinks(drinks)
                }
                fetchDrinksLocally(forSearchQuery: searchQuery)
            } catch {
                // Error handling out of scope for project?
            }
        }
    }
    
    public func saveDrinks(_ drinks: API.Model.Drinks) {
        let drinkDictionaries = drinks.drinks?.map { $0.dictionaryRepresentation() }
        LocalData.shared.saveDrinks(from: drinkDictionaries)
        fetchAllDrinks()
    }
    
    // MARK: Image Loading
    
    public func loadOrFetchImageIfNeeded(forDrink drink: SearchViewDataItem) async {
        guard let thumbURL = drink.thumbURL, drink.thumbData == nil else {
            return
        }
        
        guard let imageData = imageLoader.loadImage(forURL: thumbURL) else {
            await fetchImage(forDrink: drink)
            return
        }
        
        drink.thumbData = imageData
    }
    
    private func fetchImage(forDrink drink: SearchViewDataItem) async {
        let url = drink.thumbURL!
        guard let imageData = try? await imageLoader.fetchImage(forURL: url) else {
            return
        }
        drink.thumbData = imageData
        fetchedImageAvailableForDrink = drink
    }
    
    // MARK: Settings Actions

    public func performSettings(action: SettingsMenuAction) {
        switch action {
        case .resetImageCache: resetImageCache()
        case .resetDrinkData: resetDrinkData()
        case .resetAllData: resetAllData()
        }
    }
    
    public func resetImageCache() {
        imageLoader.clearCache()
        fetchedImageAvailableForDrink = nil
        fetchAllDrinks()
    }
    
    public func resetDrinkData() {
        LocalData.shared.deleteAllData()
        groupedDrinks = [:]
        searchResults = []
        sectionIndexTitles = []
        fetchedImageAvailableForDrink = nil
        fetchAllDrinks()
    }
    
    public func resetAllData() {
        resetImageCache()
        resetDrinkData()
    }
    
    // MARK: Navigation
    
    public func showDetails(forDrink drink: SearchViewDataItem) {
        coordinator.navigateToDetails(forDrinkID: drink.id)
    }
    
}

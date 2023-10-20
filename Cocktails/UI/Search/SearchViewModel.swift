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

    // MARK: Props (private)
    
    private var currentSearchQuery: String?
    private var api = API()

    // MARK: Fetch
    
    public func fetchDrinksDebounced(for searchQuery: String) {
        currentSearchQuery = searchQuery
        
        let selector = #selector(fetchDrinksForSearchQuery)
        performDebounced(selector, afterDelay: Metric.userInputDebounceInterval)
    }

    @objc private func fetchDrinksForSearchQuery() {
        guard let currentSearchQuery = currentSearchQuery, !currentSearchQuery.isEmpty else {
            return
        }
        
        debugPrint("Fetching drinks for search: \"\(currentSearchQuery)\"")

        Task {
            do {
                let drinks = try await api.fetchDrinks(forQuery: currentSearchQuery)
                debugPrint("Results for search \"\(currentSearchQuery)\":\n\(drinks)")
            } catch {
                // TODO: Error handling out of scope?
            }
        }
    }
    
    
}

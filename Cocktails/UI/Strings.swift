//
//  Strings.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

struct Strings {
    
    struct SearchView {
        let title = "Cocktails"
        let searchPlaceholder = "Search"
        let emptyDataSetTitle = "Get Started with Cocktails"
        let emptyDataSetDetail = "Use the search bar to find cocktail recipes. Recipes you've searched for will appear here."
        let emptySearchTitle = "No Results for"
        let emptySearchDetail = "Try searching for a different cocktail."
        let emptyStartSearchTitle = "Search Cocktails"
        let emptyStartSearchDetail = "Find your favourite cocktail recipes."
        
        let numericSectionIndexTitle = "#"
        let emptySpace = String(UnicodeScalar(32))
        let resultsFor = "Results for"
        let settings = "Settings"
        let resetImageCache = "Reset Image Cache"
        let resetDrinkData = "Reset Drinks Data"
        let resetAllData = "Reset All Data"
    }
    
    struct DetailView {
        let cocktails = "Cocktails"
        let instructions = "Instructions"
        let ingredients = "Ingredients"
    }

}

//
//  SearchViewDataItem.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

protocol SearchViewDataViewModel {
    init(drink: Drink)
    
    var name: String {get}
    var instructions: String {get}
}

class SearchViewDataItem: SearchViewDataViewModel {
    
    private var drink: Drink!
    
    required init(drink: Drink) {
        self.drink = drink
    }
    
    public var name: String {
        drink.strDrink ?? ""
    }
    
    public var instructions: String {
        drink.strInstructions ?? ""
    }
    
}

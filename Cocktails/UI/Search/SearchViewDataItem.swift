//
//  SearchViewDataItem.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

protocol SearchViewDataViewModel {
    init(drink: Drink)
    
    var id: String {get}
    var name: String {get}
    var instructions: String {get}
    var thumbURL: URL? {get}
    var thumbData: Data? {get set}

}

class SearchViewDataItem: SearchViewDataViewModel {
    
    private var drink: Drink!
    
    required init(drink: Drink) {
        self.drink = drink
    }
    
    public var id: String { drink.idDrink ?? "" }
    public var name: String { drink.strDrink ?? "" }
    public var instructions: String { drink.strInstructions ?? "" }
    public var thumbURL: URL? { URL(string: drink.strDrinkThumb  ?? "") }
    public var thumbData: Data? 
}

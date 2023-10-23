//
//  DetailViewDataItem.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

protocol DetailViewDataViewModel {
    init(drink: Drink)
    
    var name: String {get}
    var imageURL: URL? {get}
    var thumbURL: URL? {get}
    var videoURL: URL? {get}
    var tags: [String] {get}
    var ingredients: [String] {get}
    var instructions: String {get}
    var hasVideo: Bool {get}

}

class DetailViewDataItem: DetailViewDataViewModel {
    
    private var drink: Drink!
    
    required init(drink: Drink) {
        self.drink = drink
    }
   
    public var name: String { drink.strDrink ?? "" }
    public var imageURL: URL? { URL(string: drink.strImageSource  ?? "") }
    public var thumbURL: URL? { URL(string: drink.strDrinkThumb  ?? "") }
    public var videoURL: URL? { URL(string: drink.strVideo  ?? "") }
    public var tags: [String] { drink.tags }
    public var ingredients: [String] { drink.ingredients }
    public var instructions: String { drink.strInstructions ?? "" }
    public var hasVideo: Bool { videoURL != nil }
}

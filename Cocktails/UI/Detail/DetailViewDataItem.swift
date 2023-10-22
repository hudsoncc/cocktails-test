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
    var imageLink: String? {get}
    var thumbLink: String? {get}
    var videoLink: String? {get}
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
    public var imageLink: String? { drink.strImageSource }
    public var thumbLink: String? { drink.strDrinkThumb }
    public var videoLink: String? { drink.strVideo }
    public var tags: [String] { drink.tags }
    public var ingredients: [String] { drink.ingredients }
    public var instructions: String { drink.strInstructions ?? "" }
    public var hasVideo: Bool { videoLink != nil }
}

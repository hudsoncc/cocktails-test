//
//  API+Model.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

extension API {
    struct Model {
        // Model Namespace.
    }
}

extension API.Model {
    
    struct Drinks: Decodable, DictionaryRepresentable {
        var drinks: [Drink]?
    }
    
    struct Drink: Codable, DictionaryRepresentable {
        var idDrink: String
        var strDrink: String
        var strInstructions: String?
        var strTags: String?
        var strImageSource: String?
        var strDrinkThumb: String?
        var strVideo: String?
        var strIngredient1: String?
        var strIngredient2: String?
        var strIngredient3: String?
        var strIngredient4: String?
        var strIngredient5: String?
        var strIngredient6: String?
        var strIngredient7: String?
        var strIngredient8: String?
        var strIngredient9: String?
        var strIngredient10: String?
        var strIngredient11: String?
        var strIngredient12: String?
        var strIngredient13: String?
        var strIngredient14: String?
        var strIngredient15: String?
    }
    
}

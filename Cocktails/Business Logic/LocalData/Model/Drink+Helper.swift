//
//  Drink+Helper.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

extension Drink {
    
    public var tags: [String] {
        strTags?.components(separatedBy: ",") ?? []
    }

    public var ingredients: [String] {
        let baseKey = "strIngredient"
        var ingredients = [String]()
        
        for i in 1...15 {
            let key = "\(baseKey)\(i)"
            if let anIngredient = value(forKey: key) as? String {
                ingredients.append(anIngredient)
            } else {
                break
            }
        }
        return ingredients
    }
    
    // Search
    
    static let searchSubstituteKey: String = "query"

    static var searchQueryPredicates: NSPredicate {
        let predicates = searchableProperties.map {
            NSPredicate(format: "%K CONTAINS[cd] $\(searchSubstituteKey)", $0)
        }
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    static private var searchableProperties: [String] {
        [
            #keyPath(Drink.strDrink),
            #keyPath(Drink.strIngredient1),
            #keyPath(Drink.strIngredient2),
            #keyPath(Drink.strIngredient3),
            #keyPath(Drink.strIngredient4),
            #keyPath(Drink.strIngredient5),
            #keyPath(Drink.strIngredient6),
            #keyPath(Drink.strIngredient7),
            #keyPath(Drink.strIngredient8),
            #keyPath(Drink.strIngredient9),
            #keyPath(Drink.strIngredient10),
            #keyPath(Drink.strIngredient11),
            #keyPath(Drink.strIngredient12),
            #keyPath(Drink.strIngredient13),
            #keyPath(Drink.strIngredient14),
            #keyPath(Drink.strIngredient15),
            #keyPath(Drink.strTags)
        ]
        
    }
    
}

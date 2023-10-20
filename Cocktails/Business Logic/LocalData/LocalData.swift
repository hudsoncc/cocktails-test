//
//  LocalData.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation
import CoreData

class LocalData: NSObject {
    
    // MARK: - Props (private)
    
    let coreData = CoreDataStack()
    
    // MARK: Life cycle
    
    static let shared = LocalData()
    
    public func load() async throws {
        try await coreData.load()
    }

    // MARK: Drinks
    
    public func fetchDrinks(forQuery searchQuery: String, context: NSManagedObjectContext? = nil) -> [Drink] {
        let predicate = Drink.searchQueryPredicates.withSubstitutionVariables(["query": searchQuery])

        return coreData.fetchObjects(predicate: predicate, in: context)
    }
    
    public func fetchDrinks(context: NSManagedObjectContext? = nil) -> [Drink] {
        coreData.fetchObjects(in: context)
    }
    
    public func saveDrinks(from drinkDictionaries: [[String:Any?]]?) {
        let idKey = #keyPath(Drink.idDrink)
        coreData.saveObjects(ofType: Drink.self, from: drinkDictionaries, idKey: idKey)
    }
    
    
}

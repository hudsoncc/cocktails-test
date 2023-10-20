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
    
}

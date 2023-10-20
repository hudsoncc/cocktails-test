//
//  API+Endpoint.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

extension API {
    
    enum Endpoint: String {
        case search
    }
    
}

extension API.Endpoint {
    
    static let baseUrl = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/")!

    var urlValue: URL {
        URL(string: "\(Self.baseUrl)\(rawValue).php")!
    }

}

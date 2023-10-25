//
//  DataMapper.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

protocol DictionaryRepresentable {
    func dictionaryRepresentation() -> [String : Any?]
}

extension DictionaryRepresentable {
    
    func dictionaryRepresentation() -> [String : Any?] {
        let mirror = Mirror(reflecting: self)
        var dict = [String : Any]()
        for child in mirror.children  {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
    
}

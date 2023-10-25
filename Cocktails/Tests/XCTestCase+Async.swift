//
//  XCTestCase+Async.swift
//  CocktailsTests
//
//  Created by Hudson Maul on 25/10/2023.
//

import XCTest

extension XCTestCase {
    
    func waitAsync(description: String, wait: TimeInterval = 0.3, timeOut: TimeInterval, asyncBlock: @escaping ()->()) async {
        let alertExpectation = XCTestExpectation(description: description)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + wait, execute: {
            asyncBlock()
            alertExpectation.fulfill()
        })
        
        await fulfillment(of: [alertExpectation], timeout: timeOut)
    }
}

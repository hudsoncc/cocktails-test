//
//  NSObject+Debounce.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

extension NSObject {
    
    /// Debounces calls to the `selector` based on the passed in delay.
    func performDebounced(_ selector: Selector, with object: Any? = nil, afterDelay delay: TimeInterval = 1) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: object)
        perform(selector, with: object, afterDelay: delay, inModes: [.common])
    }
    
}

//
//  ViewModel.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation

class ViewModel {
    
    // MARK: Props (public)
    
    public var coordinator: ViewCoordinator!
    
    // MARK: Life cycle
    
    init(coordinator: ViewCoordinator) {
        self.coordinator = coordinator
    }
    
}

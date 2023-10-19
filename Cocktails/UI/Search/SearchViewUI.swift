//
//  SearchUI.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import UIKit

class SearchViewUI: NSObject {
        
    // MARK: Props (private)
    
    private var viewController: SearchViewController!
    private var view: UIView { viewController.view }
    
    // MARK: Life cycle
    
    convenience init(for viewController: SearchViewController) {
        self.init()
        
        self.viewController = viewController
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
    }
    
}

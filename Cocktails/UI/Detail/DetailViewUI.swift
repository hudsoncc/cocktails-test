//
//  DetailViewUI.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import UIKit

class DetailViewUI: NSObject {
    
    // MARK: Props (private)
    
    private var view: UIView { viewController.view }
    private var viewController: DetailViewController!
    
    // MARK: Life cycle
    
    convenience init(for viewController: DetailViewController) {
        self.init()
        
        self.viewController = viewController
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
    }
    
}
    


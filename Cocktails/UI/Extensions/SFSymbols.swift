//
//  UIImage+Symbols.swift
//  Cocktails
//
//  Created by Hudson Maul on 21/10/2023.
//

import UIKit

extension UIImage {
    
    convenience init?(symbol: String, size: CGFloat, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .medium) {
        let config = UIImage.SymbolConfiguration(
            pointSize: size, weight: weight, scale: scale
        )
        self.init(systemName: symbol, withConfiguration: config)
    }
}

extension UIBarButtonItem {

    convenience init(symbol: String, size: CGFloat, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .medium, target: Any?, action: Selector?) {
        
        let image = UIImage(symbol: symbol, size: size, weight: weight, scale: scale)
        self.init(image: image, style: .plain, target: target, action: action)
    }
   
    
}


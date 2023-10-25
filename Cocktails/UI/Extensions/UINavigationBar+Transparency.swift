//
//  UINavigationBar+Transparency.swift
//  Cocktails
//
//  Created by Hudson Maul on 22/10/2023.
//

import UIKit

extension UINavigationBar {
  
    var prefersTransparentBackground: Bool {
        get {
            shadowImage == nil && backgroundImage(for: .default) == nil
        }
        set {
            let image: UIImage? = newValue ? UIImage() : nil
            setBackgroundImage(image, for: .default)
            shadowImage = image
        }
    }
   
}


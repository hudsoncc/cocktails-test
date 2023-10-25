//
//  UIEdgeInsets+Additions.swift
//  Cocktails
//
//  Created by Hudson Maul on 21/10/2023.
//

import UIKit

extension UIEdgeInsets {
    
    init(all: CGFloat, invertsBottomRight: Bool = false) {
        self.init(
            top: all,
            left: all,
            bottom: invertsBottomRight ? -all : all,
            right: invertsBottomRight ? -all : all
        )
    }
    
    init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
}

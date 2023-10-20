//
//  UITableViewCell+ID.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import Foundation

import UIKit

extension UITableViewCell {
    class var cellID: String { return "\(self)ID" }
}

extension UITableView {
    
    func registerCells(_ cellClasses: [UITableViewCell.Type]) {
        for aCellClass in cellClasses {
            register(aCellClass.self, forCellReuseIdentifier: aCellClass.cellID)
        }
    }
}

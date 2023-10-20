//
//  SearchViewCell.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    // MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Configure
    
    public func configure(for dataItem: SearchViewDataItem) {
        textLabel?.text = dataItem.name
        detailTextLabel?.text = dataItem.instructions
    }
}

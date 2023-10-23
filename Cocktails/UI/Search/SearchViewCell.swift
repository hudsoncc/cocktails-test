//
//  SearchViewCell.swift
//  Cocktails
//
//  Created by Hudson Maul on 20/10/2023.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    // MARK: Props (private)
    
    private let containerView = UIStackView()
    private let labelContainerView = UIStackView()
    private let symbolView = UIImageView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private var placeHolderImage: UIImage = {
        let image = UIImage(symbol: "wineglass", size: 22, scale: .large)!
        return image
    }()

    // MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        addContainerView()
        addSymbolView()
        addLabelContainerView()
        addTitleLabel()
        addInfoLabel()
        
        configure(forImageData: nil)
    }
    
    // MARK: Subviews
    
    private func addContainerView() {
        containerView.axis = .horizontal
        containerView.spacing = .paddingS
        containerView.distribution = .fill
        containerView.alignment = .top
        contentView.addSubview(containerView)
        containerView.anchorFill(.init(all: .padding, invertsBottomRight: true))
    }
    
    private func addSymbolView() {
        symbolView.clipsToBounds = true
        symbolView.backgroundColor = .black
        symbolView.tintColor = .white
        symbolView.layer.cornerRadius = 10
        symbolView.layer.cornerCurve = .continuous
        containerView.addArrangedSubview(symbolView)
        symbolView.anchorWidth(74, height: 74)
    }
    
    private func addLabelContainerView() {
        labelContainerView.axis = .vertical
        labelContainerView.spacing = .paddingXS
        containerView.addArrangedSubview(labelContainerView)
    }
    
    private func addTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16)
        labelContainerView.addArrangedSubview(titleLabel)
    }
    
    private func addInfoLabel() {
        infoLabel.font = .systemFont(ofSize: 14)
        infoLabel.numberOfLines = 4
        infoLabel.textColor = .secondaryLabel
        infoLabel.lineBreakMode = .byTruncatingTail
        labelContainerView.addArrangedSubview(infoLabel)
    }
    
    // MARK: Configure
    
    public func configure(for dataItem: SearchViewDataItem) {
        titleLabel.text = dataItem.name
        infoLabel.text = dataItem.instructions
         
    }
}

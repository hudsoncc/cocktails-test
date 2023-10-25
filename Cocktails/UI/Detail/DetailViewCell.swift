//
//  DetailViewCell.swift
//  Cocktails
//
//  Created by Hudson Maul on 21/10/2023.
//

import UIKit

class DetailViewCell: UITableViewCell {
    
    // MARK: Props (private)

    private let containerView = UIStackView()
    private let labelContainerView = UIStackView()
    private let symbolView = UIImageView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    
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
        symbolView.contentMode = .center
        containerView.addArrangedSubview(symbolView)
        symbolView.anchorWidth(34, height: 34)
    }
    
    private func addLabelContainerView() {
        labelContainerView.axis = .vertical
        labelContainerView.spacing = .paddingS
        containerView.addArrangedSubview(labelContainerView)
    }
    
    private func addTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        labelContainerView.addArrangedSubview(titleLabel)
    }
    
    private func addInfoLabel() {
        infoLabel.font = .preferredFont(forTextStyle: .body)
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .secondaryLabel
        labelContainerView.addArrangedSubview(infoLabel)
    }
    
    // MARK: Configure
    
    public func configure(title: String, info: String, symbol: String) {
        let image = UIImage(symbol: symbol, size: 26, weight: .regular, scale: .large)
        symbolView.image = image
        titleLabel.text = title
        infoLabel.text = info
    }
}

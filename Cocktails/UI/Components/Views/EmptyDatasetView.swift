//
//  EmptyDatasetView.swift
//  Cocktails
//
//  Created by Hudson Maul on 19/10/2023.
//

import Foundation
import UIKit

class EmptyDatasetView: UIView {
    
    struct Metric {
        static let symbolHeight: CGFloat = 70
    }
    
    // MARK: Props (public)
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var detail: String? {
        didSet {
            detailLabel.text = detail
        }
    }
    
    public var symbol: String? {
        didSet {
            guard let symbol = symbol else {
                imageView.image = nil
                return
            } 
            let image = UIImage(systemName: symbol, withConfiguration: symbolConfiguration)
            imageView.image = image
        }
    }

    // MARK: Props (private)

    private let contentView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addContentView()
        addFlexibleSpace()
        addImageView()
        addTitleLabel()
        addDetailLabel()
        addFlexibleSpace()
    }
    
    private func addContentView() {
        contentView.axis = .vertical
        contentView.spacing = .paddingS
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = .init(top: .zero, left: .paddingM, bottom: .zero, right: .paddingM)
        addSubview(contentView)
        
        contentView.anchorFillHorizontally()
        contentView.anchorCenterY()
    }
    
    private func addImageView() {
        imageView.contentMode = .scaleAspectFit
        contentView.addArrangedSubview(imageView)
        imageView.anchorHeight(Metric.symbolHeight)
    }
    
    private func addTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        contentView.addArrangedSubview(titleLabel)
    }
    
    private func addDetailLabel() {
        detailLabel.textAlignment = .center
        detailLabel.textColor = .secondaryLabel
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.numberOfLines = .zero
        detailLabel.adjustsFontForContentSizeCategory = true
        contentView.addArrangedSubview(detailLabel)
    }
    
    private func addFlexibleSpace() {
        contentView.addArrangedSubview(UIView())
    }
    
}

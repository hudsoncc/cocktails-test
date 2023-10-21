//
//  DetailHeaderView.swift
//  Cocktails
//
//  Created by Hudson Maul on 21/10/2023.
//

import UIKit

class DetailHeaderView: UIView {
    
    // MARK: Structs

    struct Metric {
        static let imageViewHeight: CGFloat = 200
    }
    
    // MARK: Props (public)
    
    private var supertitle: String! {
        didSet {
            supertitleLabel.text = supertitle
        }
    }
    
    private var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
        
    private var image: UIImage?  {
        didSet {
            imageView.image = image
        }
    }

    // MARK: Props (private)
    
    private var imageView = UIImageView()
    private var contentView = UIStackView()
    private var supertitleLabel = UILabel()
    private var titleLabel = UILabel()

    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        backgroundColor = .secondarySystemBackground

        addImageView()
        addContentView()
        addSupertitleLabel()
        addTitleLabel()
    }
    
    private func addImageView() {
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.anchorHeight(Metric.imageViewHeight)
        imageView.anchorFill()
    }
    
    private func addContentView() {
        contentView.spacing = .paddingS
        contentView.axis = .vertical
        contentView.distribution = .fill
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = .init(all: .paddingM)
        addSubview(contentView)
        contentView.anchorEdges([.bottom, .left, .right])
    }
    
    private func addSupertitleLabel() {
        supertitleLabel.text = "Supertitle".uppercased()
        supertitleLabel.font = .preferredFont(forTextStyle: .caption1)
        supertitleLabel.alpha = 0.3
        contentView.addArrangedSubview(supertitleLabel)
    }
    
    private func addTitleLabel() {
        titleLabel.text = "Title"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        contentView.addArrangedSubview(titleLabel)
    }
}

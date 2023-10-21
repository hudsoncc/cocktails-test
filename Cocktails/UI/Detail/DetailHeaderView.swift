//
//  DetailHeaderView.swift
//  Cocktails
//
//  Created by Hudson Maul on 21/10/2023.
//

import UIKit

class DetailHeaderView: UIView {
    
    // MARK: Props (public)
    
    public var supertitle: String! {
        didSet {
            supertitleLabel.text = supertitle.uppercased()
        }
    }
    
    public var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
        
    public var image: UIImage?  {
        didSet {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }
    
        }
    }

    // MARK: Props (private)
    
    private let imageView = UIImageView()
    private let contentView = UIStackView()
    private let supertitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()

    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        backgroundColor = .black

        addImageView()
        addGradientView()
        addContentView()
        addSupertitleLabel()
        addTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
    
    // MARK: Subviews
    
    private func addImageView() {
        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 100, weight: .regular, scale: .large
        )
        let image = UIImage(systemName: "wineglass", withConfiguration: symbolConfiguration)
        imageView.image = image
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.anchorFill()
    }
    
    private func addContentView() {
        contentView.spacing = .paddingS
        contentView.axis = .vertical
        contentView.distribution = .fill
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = .init(bottom: .paddingM, left: .padding, right: .padding)
        addSubview(contentView)
        contentView.anchorEdges([.bottom, .left, .right])
    }
    
    private func addSupertitleLabel() {
        supertitleLabel.text = "Supertitle".uppercased()
        supertitleLabel.textColor = .white.withAlphaComponent(0.5)
        supertitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        contentView.addArrangedSubview(supertitleLabel)
        contentView.setCustomSpacing(0, after: supertitleLabel)
    }
    
    private func addTitleLabel() {
        titleLabel.text = "Title"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 38, weight: .bold)
        titleLabel.numberOfLines = 0
        contentView.addArrangedSubview(titleLabel)
    }
    
    private func addGradientView() {
        let color = UIColor.black
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor, color.cgColor]
        gradientLayer.locations = [0.0, 1.0]

        gradientView.layer.addSublayer(gradientLayer)
        addSubview(gradientView)
        gradientView.anchorHeight(200)
        gradientView.anchorEdges([.bottom, .left, .right])
        layoutIfNeeded()
    }
}

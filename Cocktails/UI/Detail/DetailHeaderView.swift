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
    
    public var tags: [String] = []  {
        didSet {
            guard !tags.isEmpty else { return }
            tagView.tags = tags
        }
    }
    
    public var onTap: (()->())?
    
    // MARK: Props (private)
    
    private let imageContainerView = UIView()
    private let imageView = UIImageView()
    private let contentView = UIStackView()
    private let supertitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let actionButton = UIButton()
    
    private lazy var tagView: TagView = {
        let tagView = TagView()
        tagView.tagColor = .white.withAlphaComponent(0.2)
        tagView.tagTextColor = .white
        contentView.addArrangedSubview(tagView)
        tagView.anchorMinimumHeight(24)
        return tagView
    }()
    
    private var imageContainerTopConstraint = NSLayoutConstraint()
    private var imageContainerHeightConstraint = NSLayoutConstraint()
    
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
        addImageContainerView()
        addImageView()
        addGradientView()
        addContentView()
        addSupertitleLabel()
        addTitleLabel()
        addActionButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
   
    // MARK: Subviews
    
    private func addImageContainerView() {
        imageContainerView.clipsToBounds = true
        addSubview(imageContainerView)
        imageContainerView.anchorEdges([.left,.right])
        imageContainerTopConstraint = imageContainerView.anchorEdges([.top]).first!
        imageContainerHeightConstraint = imageContainerView.anchorToHeight()
    }
    
    private func addImageView() {
        imageView.image = UIImage(symbol: "wineglass", size: 100, scale: .large)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.tintColor = .white
        imageContainerView.addSubview(imageView)
        imageView.anchorEdges([.top, .left, .right])
        imageView.anchorToHeight()
    }
    
    private func addContentView() {
        contentView.spacing = .paddingS
        contentView.axis = .vertical
        contentView.distribution = .fill
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = .init(bottom: .paddingM, left: .padding, right: .padding)
        addSubview(contentView)
        contentView.anchorEdges([.left, .bottom, .right])
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
    
    private func addActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonWasTapped), for: .touchUpInside)
        addSubview(actionButton)
        actionButton.anchorFill()
    }
    
    @objc private func actionButtonWasTapped() {
        onTap?()
    }
    
    // MARK: Image zoom on scroll
    
    public func zoomImageForChange(inScrollView scrollView: UIScrollView) {
        let newTopInset = scrollView.contentInset.top
        let newOffsetY = -(scrollView.contentOffset.y + newTopInset)
        let newHeight = max(newOffsetY + newTopInset, newTopInset)
        
        
        if scrollView.contentOffset.y < 0 {
            imageContainerTopConstraint.constant = -newOffsetY
            imageContainerHeightConstraint.constant = newHeight
        }
    }


}

//
//  TagView.swift
//  Cocktails
//
//  Created by Hudson Maul on 21/10/2023.
//

import UIKit

class TagView: UICollectionView {
    
    // MARK: Structs
    
    struct Metric {
        static let spacing: CGFloat = 8
        static let estimatedItemWidth: NSCollectionLayoutDimension = .estimated(100)
        static let itemHeight: NSCollectionLayoutDimension = .absolute(20)
    }
    
    // MARK: Enums
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    // MARK: Props (public)
    
    public var tags: [String] = [] {
        didSet {
            configureDataSource()
        }
    }
    
    public var tagColor: UIColor = .tintColor
    public var tagTextColor: UIColor = .white

    override public var intrinsicContentSize: CGSize {
        collectionViewLayout.collectionViewContentSize
    }
    
    // MARK: Props (private)
    
    private var source: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    
    // MARK: Life cycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: Self.tagLayout())
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        contentInset = .zero
        contentOffset = .zero
        allowsMultipleSelection = true
        contentInsetAdjustmentBehavior = .never
        
        register(TagView.Cell.self, forCellWithReuseIdentifier: "\(TagView.Cell.self)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentSizeIfNeeded()
    }
    
    private func updateContentSizeIfNeeded() {
        guard bounds.size != intrinsicContentSize else { return }
        invalidateIntrinsicContentSize()
    }
    
    // MARK: Data source
    
    private func configureDataSource() {
        let cellReg = UICollectionView.CellRegistration<TagView.Cell, AnyHashable> { [weak self] cell, indexPath, id in
            guard let self else { return }
            
            let tag = tags[indexPath.item]
            cell.textLabel.text = tag
            cell.textLabel.textColor = tagTextColor
            cell.backgroundColor = tagColor
        }
        
        source = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: self) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: item)
        }
        
        updateDataSnapshot(animated: false)
    }
    
    private func updateDataSnapshot(animated: Bool) {
        guard dataSource != nil else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        let tagIndexes = tags.isEmpty ? [] : Array(0...tags.count-1)
        snapshot.appendSections([.main])
        snapshot.appendItems(tagIndexes)
        source.apply(snapshot, animatingDifferences: animated)
    }
    
    // MARK: Layout
    
    private class func tagLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let item = layoutItem()
            let group = layoutGroup(withItem: layoutItem())
            let section = layoutSection(withGroup: group)
            return section
        }
        return layout
    }
    
    private class func layoutItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: Metric.estimatedItemWidth,
            heightDimension: Metric.itemHeight
        )
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
    
    private class func layoutGroup(withItem item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), 
            heightDimension: item.layoutSize.heightDimension
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item]
        )
        group.interItemSpacing = .fixed(Metric.spacing)
        group.edgeSpacing = .none
        return group
    }
    
    private class func layoutSection(withGroup group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Metric.spacing
        section.contentInsets = .zero
        return section
    }
    
}

extension TagView {
    
    class Cell: UICollectionViewCell {
        
        // MARK: Props (public)
        
        private(set) var textLabel = UILabel()
        
        // MARK: Life cycle
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            layer.cornerRadius = 6
            layer.cornerCurve = .continuous
            addTextLabel()
        }
        
        private func addTextLabel() {
            textLabel.text = "Tag"
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            textLabel.lineBreakMode = .byWordWrapping
            textLabel.font = .preferredFont(forTextStyle: .caption1)
            addSubview(textLabel)
            textLabel.anchorCenterY()
            textLabel.anchorFill(.init(top: 0, left: 8, bottom: 0, right: -8))
        }
        
    }
    
}

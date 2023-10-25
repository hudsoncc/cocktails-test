//
//  VibrancyButton.swift
//  Cocktails
//
//  Created by Hudson Maul on 22/10/2023.
//

import UIKit

class VibrancyButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        backgroundColor = nil
        clipsToBounds = true
        tintColor = .white
        layer.cornerCurve = .continuous

        addVibrancyView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func addVibrancyView() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let vibrancyView = UIVisualEffectView(effect: blurEffect)
        vibrancyView.isUserInteractionEnabled = false
        insertSubview(vibrancyView, belowSubview: imageView!)

        vibrancyView.contentView.addSubview(imageView!)
        vibrancyView.contentView.addSubview(titleLabel!)

        vibrancyView.anchorFill()
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = bounds.height / 2
    }
}

class VibrancyBarButtonItem: UIBarButtonItem {
    
    struct Metric {
        static let symbolSize = CGFloat(15)
        static let size = CGSize(width: 34, height: 34)
    }
    
    convenience init(symbol: String, target: Any?, action: Selector?) {
        let button = VibrancyButton()
        let image = UIImage(symbol: symbol, size: Metric.symbolSize, weight: .bold, scale: .medium)
        button.setImage(image, for: .normal)
        
        if let action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        self.init(customView: button)
        button.anchorSize(Metric.size)
    }
    
}

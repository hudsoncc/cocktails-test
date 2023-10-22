//
//  UIView+Anchors.swift
//
//  Created by Hudson Maul on 12/01/2022.
//

import UIKit

extension UIView {
    
    @discardableResult public func anchorFill(_ insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        anchorEdges([.all], insets: insets)
    }
    
    @discardableResult public func anchorEdges(_ edges: [UIRectEdge], insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        let isAll = edges.contains(.all)
        var constraints = [NSLayoutConstraint]()
        
        if isAll || edges.contains(.top) {
            let constraint = topAnchor.constraint(equalTo: superview!.topAnchor, constant: insets.top)
            constraint.isActive = true
            constraints.append(constraint)
        }
        if isAll || edges.contains(.left) {
            let constraint = leftAnchor.constraint(equalTo: superview!.leftAnchor, constant: insets.left)
            constraint.isActive = true
            constraints.append(constraint)
        }
        if isAll || edges.contains(.right) {
            let constraint = rightAnchor.constraint(equalTo: superview!.rightAnchor, constant: insets.right)
            constraint.isActive = true
            constraints.append(constraint)
        }
        if isAll || edges.contains(.bottom) {
            let constraint = bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: insets.bottom)
            constraint.isActive = true
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    public func anchorFillSafeArea(_ insets: UIEdgeInsets = .zero) {
        anchorSafeAreaEdges([.all], insets: insets)
    }
    
    public func anchorSafeAreaEdges(_ edges: [UIRectEdge], insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let isAll = edges.contains(.all)
        
        if isAll || edges.contains(.top) {
            topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
        }
        if isAll || edges.contains(.left) {
            leftAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leftAnchor, constant: insets.left).isActive = true
        }
        if isAll || edges.contains(.right) {
            rightAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.rightAnchor, constant: insets.right).isActive = true
        }
        if isAll || edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom).isActive = true
        }
    }
    
    public func anchorFillHorizontally(insets: UIEdgeInsets = .zero) {
        anchorEdges([.left, .right], insets: insets)
    }
    
    public func anchorFillLayoutGuide(_ insets: UIEdgeInsets = .zero) {
        anchorLayoutGuideEdges([.all], insets: insets)
    }
    
    public func anchorLayoutGuideEdges(_ edges: [UIRectEdge], insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let isAll = edges.contains(.all)
        
        if isAll || edges.contains(.top) {
            topAnchor.constraint(equalTo: superview!.layoutMarginsGuide.topAnchor, constant: insets.top).isActive = true
        }
        if isAll || edges.contains(.left) {
            leftAnchor.constraint(equalTo: superview!.layoutMarginsGuide.leftAnchor, constant: insets.left).isActive = true
        }
        if isAll || edges.contains(.right) {
            rightAnchor.constraint(equalTo: superview!.layoutMarginsGuide.rightAnchor, constant: insets.right).isActive = true
        }
        if isAll || edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview!.layoutMarginsGuide.bottomAnchor, constant: insets.bottom).isActive = true
        }
    }
    
    public func anchorFillReadableGuide(_ insets: UIEdgeInsets = .zero) {
        anchorSafeAreaEdges([.all], insets: insets)
    }
    
    public func anchorFillReadableGuideEdges(_ edges: [UIRectEdge], insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let isAll = edges.contains(.all)
        
        if isAll || edges.contains(.top) {
            topAnchor.constraint(equalTo: superview!.readableContentGuide.topAnchor, constant: insets.top).isActive = true
        }
        if isAll || edges.contains(.left) {
            leftAnchor.constraint(equalTo: superview!.readableContentGuide.leftAnchor, constant: insets.left).isActive = true
        }
        if isAll || edges.contains(.right) {
            rightAnchor.constraint(equalTo: superview!.readableContentGuide.rightAnchor, constant: insets.right).isActive = true
        }
        if isAll || edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview!.readableContentGuide.bottomAnchor, constant: insets.bottom).isActive = true
        }
    }
    
    public func anchorTop(inset: CGFloat? = nil) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: superview!.topAnchor, constant: inset ?? 0)
        constraint.isActive = true
        return constraint
    }
    
    public func anchorCenterX(offset: CGFloat = .zero) {
        anchorCenter(.horizontal, x: offset)
    }
    
    public func anchorCenterY(offset: CGFloat = .zero, of parentView: UIView? = nil) {
        anchorCenter(.vertical, y: offset)
    }
    
    public func anchorSafeAreaCenterY(offset: CGFloat = .zero, of parentView: UIView? = nil) {
        anchorCenter(.vertical, y: offset, isSafeArea: true)
    }
    
    @discardableResult public func anchorCenter(_ axis: NSLayoutConstraint.Axis? = nil, of parentView: UIView? = nil, x: CGFloat = .zero, y: CGFloat = .zero, isSafeArea: Bool = false) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        let targetView = parentView ?? superview!
        
        if axis == nil || axis == .horizontal {
            var constraint: NSLayoutConstraint!
            
            if isSafeArea {
                constraint = centerXAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.centerXAnchor, constant: x)
            } else {
                constraint = centerXAnchor.constraint(equalTo: targetView.centerXAnchor, constant: x)
            }
            constraint.isActive = true
            constraints.append(constraint)
        }
        if axis == nil || axis == .vertical {
            var constraint: NSLayoutConstraint!
            if isSafeArea {
                constraint = centerYAnchor.constraint(equalTo: targetView.centerYAnchor, constant: y)
            } else {
                constraint = centerYAnchor.constraint(equalTo: targetView.centerYAnchor, constant: y)
            }
            constraint.isActive = true
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    public func anchor(withSize size: CGSize) {
        anchorWidth(size.width)
        anchorHeight(size.height)
    }
    
    @discardableResult public func anchorWidth(_ width: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let c = widthAnchor.constraint(equalToConstant: width)
        c.isActive = true
        return c
    }
    
    public func anchorMaximumWidth(_ maxWidth: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
    }
    
    @discardableResult public func anchorMinimumWidth(_ minWidth: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let c = widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        c.isActive = true
        return c
    }
    
    public func anchorMinimumHeight(_ minHeight: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
    }
    
    public func anchorSize(_ size: CGSize) {
        anchorWidth(size.width)
        anchorHeight(size.height)
    }
    
    public func anchorToWidthAndHeight() {
        anchorToWidth()
        anchorToHeight()
    }
    
    public func anchorWidth(_ width: CGFloat, height: CGFloat) {
        anchorWidth(width)
        anchorHeight(height)
    }
    
    public func anchorToWidth(insetBy: CGFloat = 0) {
        anchorToWidth(ofView: superview!, insetBy: insetBy)
    }
    
    public func anchorToWidth(ofView targetView: UIView, insetBy: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: targetView.widthAnchor, constant: -insetBy).isActive = true
    }
    
    public func anchorToReadableWidth(insetBy: CGFloat = 0) {
        anchorToReadableWidth(ofView: superview!, insetBy: insetBy)
    }
    
    public func anchorToReadableWidth(ofView targetView: UIView, insetBy: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: targetView.readableContentGuide.widthAnchor, constant: -insetBy).isActive = true
    }
    
    @discardableResult public func anchorMaxWidth(multiplier: CGFloat) -> NSLayoutConstraint{
        translatesAutoresizingMaskIntoConstraints = false
        
        anchorEdges([.left, .right]).forEach { constraint in
            constraint.priority = .defaultHigh
        }
        
        let constraint = widthAnchor.constraint(lessThanOrEqualTo: superview!.widthAnchor, multiplier: multiplier)
        constraint.priority = .required
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult public func anchorToMaxHeight(_ height: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    
    public func anchorToWidthPercentage(_ percentage: CGFloat = 1) {
        anchorToWidthPercentage(percentage, ofView: superview!)
    }
    
    public func anchorToWidthPercentage(_ percentage: CGFloat = 1, ofView targetView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: targetView.widthAnchor, multiplier: percentage).isActive = true
    }
    
    public func anchorToMaxWidthPercentage(_ percentage: CGFloat = 1) {
        anchorToMaxWidthPercentage(percentage, ofView: superview!)
    }
    
    public func anchorToMaxWidthPercentage(_ percentage: CGFloat = 1, ofView targetView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualTo: targetView.widthAnchor, multiplier: percentage).isActive = true
    }
    
    @discardableResult public func anchorToHeight(insetBy: CGFloat = 0) -> NSLayoutConstraint {
        anchorToHeight(ofView: superview!, insetBy: insetBy)
    }
    
    @discardableResult public func anchorToHeight(ofView targetView: UIView, insetBy: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let c = heightAnchor.constraint(equalTo: targetView.heightAnchor, constant: -insetBy)
        c.isActive = true
        return c
    }
    
    
    @discardableResult public func anchorHeight(_ height: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let c = heightAnchor.constraint(equalToConstant: height)
        c.isActive = true
        return c
    }
    
    public func anchor(edge: UIRectEdge, toSuperviewEdge: UIRectEdge, xInset: CGFloat = 0, yInset: CGFloat = 0) {
        anchor(edge: edge, toEdge: toSuperviewEdge, ofView: superview!, xInset: xInset, yInset: yInset)
    }
    
    public func anchor(edge: UIRectEdge, toEdge: UIRectEdge, ofView targetView: UIView, xInset: CGFloat = 0, yInset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        targetView.translatesAutoresizingMaskIntoConstraints = false
        
        if edge == .top || edge == .bottom {
            var anchor: NSLayoutYAxisAnchor!
            var targetAnchor: NSLayoutYAxisAnchor!
            
            if edge == .top { anchor = topAnchor }
            else if edge == .bottom { anchor = bottomAnchor }
            
            if toEdge == .top { targetAnchor = targetView.topAnchor }
            else if toEdge == .bottom { targetAnchor = targetView.bottomAnchor }
            
            anchor.constraint(equalTo: targetAnchor, constant:yInset).isActive = true
        }
        else {
            var anchor: NSLayoutXAxisAnchor!
            var targetAnchor: NSLayoutXAxisAnchor!
            
            if edge == .left { anchor = leadingAnchor }
            else if edge == .right { anchor = trailingAnchor }
            
            if toEdge == .left { targetAnchor = targetView.leadingAnchor }
            else if toEdge == .right { targetAnchor = targetView.trailingAnchor }
            
            anchor.constraint(equalTo: targetAnchor, constant:xInset).isActive = true
        }
    }
}

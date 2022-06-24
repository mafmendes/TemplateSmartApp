//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    var layouts: LayoutsWraper { return LayoutsWraper(target: self) }
}

public struct LayoutsWraper {
    public let target: UIView
}

//
// MARK: Utils
//

public extension CommonExtension where Target == NSLayoutConstraint {

    @discardableResult
    func setActive(_ state: Bool, identifier: String) -> NSLayoutConstraint {
        target.setActive(state, identifier: identifier)
    }
}

public extension NSLayoutConstraint {

    @discardableResult
    func setActive(_ state: Bool, identifier: String) -> NSLayoutConstraint {
        if state == false {
            isActive = false
            return self
        }
        (firstItem as? UIView)?.layouts.removeLayoutConstraintWith(identifier: identifier)
        (secondItem as? UIView)?.layouts.removeLayoutConstraintWith(identifier: identifier)
        guard !identifier.trim.isEmpty else {
            fatalError("Empty identifier")
        }
        self.identifier = identifier
        NSLayoutConstraint.activate([self])
        return self
    }
}

public extension LayoutsWraper {

    var saferAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func layoutConstraintsRelatedWith(_ view: UIView) -> [NSLayoutConstraint] {
        let constrainableId = view.constrainableId
        return layoutConstraints.filter { ($0.identifier?.contains(constrainableId) ?? false) }
    }

    var layoutConstraintsRelatedWithSuperView: [NSLayoutConstraint] {
        guard let constrainableId = self.target.superview?.constrainableId else { return [] }
        return layoutConstraints.filter { ($0.identifier?.contains(constrainableId) ?? false) }
    }

    var layoutConstraints: [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        var _superview = target.superview
        while let superview = _superview {
            for constraint in superview.constraints {
                if let first = constraint.firstItem as? UIView, first == target {
                    constraints.append(constraint)
                }
                if let second = constraint.secondItem as? UIView, second == target {
                    constraints.append(constraint)
                }
            }
            _superview = superview.superview
        }
        constraints.append(contentsOf: target.constraints)
        return constraints
    }

    func removeConstraints() {
        layoutConstraints.forEach { (constraint) in
            remove(constraint: constraint)
        }
        target.translatesAutoresizingMaskIntoConstraints = true
    }

    func activate(constraint: NSLayoutConstraint,
                  with identifier: String) -> NSLayoutConstraint? {
        removeLayoutConstraintWith(identifier: identifier)
        guard !identifier.trim.isEmpty else {
            fatalError("Empty identifier")
        }
        constraint.identifier = identifier
        NSLayoutConstraint.activate([constraint])
        return constraint
    }

    fileprivate func removeLayoutConstraintWith(identifier: String) {
        if let old = layoutConstraints.filter({ $0.identifier == identifier }).first {
            remove(constraint: old)
        }
    }

    func remove(constraint: NSLayoutConstraint?) {
        guard let constraint = constraint else { return }
        target.removeConstraint(constraint)
        NSLayoutConstraint.deactivate([constraint])
    }

    // Hugging => Dont want to grow
    func setGrowResistance(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        target.setContentHuggingPriority(priority, for: axis)
    }

    // Compression Resistance => Dont want to shrink
    func setCompressionResistance(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        target.setContentCompressionResistancePriority(priority, for: axis)
    }

}

//
// MARK: Composed
//

public extension LayoutsWraper {

    @discardableResult
    func stackVertical(_ views: [UIView],
                       spacing viewsInnerSpacing: CGFloat,
                       fill lastViewShouldfill: Bool,
                       margin marginToSuper: CGFloat? = nil) -> [NSLayoutConstraint] {
        target.stack(views, axis: .vertical, spacing: viewsInnerSpacing, fill: lastViewShouldfill, margin: marginToSuper)
    }

    @discardableResult
    func stackHorizontal(_ views: [UIView],
                         spacing viewsInnerSpacing: CGFloat,
                         fill lastViewShouldfill: Bool,
                         margin marginToSuper: CGFloat? = nil) -> [NSLayoutConstraint] {
        target.stack(views, axis: .horizontal, spacing: viewsInnerSpacing, fill: lastViewShouldfill, margin: marginToSuper)
    }

    func addAndSetup(scrollView: UIScrollView,
                     with view: UIView,
                     usingSafeArea: Bool,
                     offSet: CGFloat = 0) {
        if scrollView.superview == nil {
            target.addSubview(scrollView)
        }
        if view.superview == nil {
            scrollView.addSubview(view)
        }
        if usingSafeArea {
            view.layouts.edgesToSuperview(insets: .zero)
            scrollView.layouts.edgesToSuperview()
            scrollView.layouts.height(screenHeight)
        } else {
            view.layouts.edgesToSuperview(insets: target.safeAreaInsets)
            scrollView.layouts.edgesToSuperview()
            scrollView.layouts.height(screenHeight - target.safeAreaInsets.bottom.magnitude - target.safeAreaInsets.top.magnitude)
        }
    }
    
    func addAndSetup(scrollView: UIScrollView,
                     with stackViewV: UIStackView,
                     usingSafeArea: Bool) {
        if scrollView.superview == nil {
            target.addSubview(scrollView)
        }
        if stackViewV.superview == nil {
            scrollView.addSubview(stackViewV)
        }
        if usingSafeArea {
            stackViewV.common.edgeStackViewToSuperView(insets: .zero)
            scrollView.layouts.edgesToSuperview()
        } else {
            stackViewV.common.edgeStackViewToSuperView(insets: target.safeAreaInsets)
            if let topSafeAreaMagnitude = UIApplication.keyWindow?.safeAreaInsets.top.magnitude {
                scrollView.layouts.topToSuperview(offset: topSafeAreaMagnitude)
            } else {
                let topSafeAreaMagnitude: CGFloat = UIDevice.isLargeOrXLarge ? 48 : 20
                scrollView.layouts.topToSuperview(offset: topSafeAreaMagnitude)
            }
            scrollView.layouts.leadingToSuperview()
            scrollView.layouts.trailingToSuperview()
            scrollView.layouts.bottomToSuperview()
        }
    }
}

//
// MARK: TinyConstraints
//

public extension LayoutsWraper {

    @discardableResult
    func edgesToSuperview(excluding excludedEdge: TNLayoutEdge = .none,
                          insets: UIEdgeInsets = .zero,
                          priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return target.edgesToSuperview(excluding: excludedEdge, insets: insets, priority: priority)
    }

    @discardableResult
    func leadingToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil,
                            offset: CGFloat = 0,
                            relation: CommonNameSpace.ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true,
                            usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.leadingToSuperview(anchor,
                                         offset: offset,
                                         relation: relation,
                                         priority: priority,
                                         isActive: isActive,
                                         usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func trailingToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil,
                             offset: CGFloat = 0,
                             relation: CommonNameSpace.ConstraintRelation = .equal,
                             priority: UILayoutPriority = .required,
                             isActive: Bool = true,
                             usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.trailingToSuperview(anchor,
                                          offset: offset,
                                          relation: relation,
                                          priority: priority,
                                          isActive: isActive,
                                          usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func horizontalToSuperview(insets: UIEdgeInsets = .zero,
                               relation: CommonNameSpace.ConstraintRelation = .equal,
                               priority: UILayoutPriority = .required,
                               isActive: Bool = true,
                               usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        return target.horizontalToSuperview(insets: insets, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func verticalToSuperview(insets: UIEdgeInsets = .zero,
                             relation: CommonNameSpace.ConstraintRelation = .equal,
                             priority: UILayoutPriority = .required,
                             isActive: Bool = true,
                             usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        return target.verticalToSuperview(insets: insets, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func centerToSuperview(offset: CGPoint = .zero,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        return target.centerInSuperview(offset: offset, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func originToSuperview(insets: UIEdgeInsets = .zero,
                           relation: CommonNameSpace.ConstraintRelation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        return target.originToSuperview(insets: insets, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func widthToSuperview(_ dimension: NSLayoutDimension? = nil,
                          multiplier: CGFloat = 1,
                          offset: CGFloat = 0,
                          relation: CommonNameSpace.ConstraintRelation = .equal,
                          priority: UILayoutPriority = .required,
                          isActive: Bool = true,
                          usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.widthToSuperview(dimension,
                                       multiplier: multiplier,
                                       offset: offset,
                                       relation: relation,
                                       priority: priority,
                                       isActive: isActive,
                                       usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func heightToSuperview(_ dimension: NSLayoutDimension? = nil,
                           multiplier: CGFloat = 1,
                           offset: CGFloat = 0,
                           relation: CommonNameSpace.ConstraintRelation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.heightToSuperview(dimension,
                                        multiplier: multiplier,
                                        offset: offset,
                                        relation: relation,
                                        priority: priority,
                                        isActive: isActive,
                                        usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func leftToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil,
                         offset: CGFloat = 0,
                         relation: CommonNameSpace.ConstraintRelation = .equal,
                         priority: UILayoutPriority = .required,
                         isActive: Bool = true,
                         usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.leftToSuperview(anchor,
                                      offset: offset,
                                      relation: relation,
                                      priority: priority,
                                      isActive: isActive,
                                      usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func rightToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil,
                          offset: CGFloat = 0,
                          relation: CommonNameSpace.ConstraintRelation = .equal,
                          priority: UILayoutPriority = .required,
                          isActive: Bool = true,
                          usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.rightToSuperview(anchor,
                                       offset: offset,
                                       relation: relation,
                                       priority: priority,
                                       isActive: isActive,
                                       usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func topToSuperview(_ anchor: NSLayoutYAxisAnchor? = nil,
                        offset: CGFloat = 0,
                        relation: CommonNameSpace.ConstraintRelation = .equal,
                        priority: UILayoutPriority = .required,
                        isActive: Bool = true,
                        usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.topToSuperview(anchor, offset: offset, relation: relation, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func bottomToSuperview(_ anchor: NSLayoutYAxisAnchor? = nil,
                           offset: CGFloat = 0,
                           relation: CommonNameSpace.ConstraintRelation = .equal,
                           priority: UILayoutPriority = .required,
                           isActive: Bool = true,
                           usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.bottomToSuperview(anchor,
                                        offset: offset,
                                        relation: relation,
                                        priority: priority,
                                        isActive: isActive,
                                        usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func centerXToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil,
                            offset: CGFloat = 0,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true,
                            usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.centerXToSuperview(anchor, offset: offset, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
    }

    @discardableResult
    func centerYToSuperview(_ anchor: NSLayoutYAxisAnchor? = nil,
                            offset: CGFloat = 0,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true,
                            usingSafeArea: Bool = false) -> NSLayoutConstraint {
        return target.centerYToSuperview(anchor, offset: offset, priority: priority, isActive: isActive, usingSafeArea: usingSafeArea)
    }
}

extension LayoutsWraper: TNConstrainable {
    public var topAnchor: NSLayoutYAxisAnchor { return target.topAnchor }
    public var bottomAnchor: NSLayoutYAxisAnchor { return target.topAnchor }
    public var leftAnchor: NSLayoutXAxisAnchor { return target.leftAnchor }
    public var rightAnchor: NSLayoutXAxisAnchor { return target.rightAnchor }
    public var leadingAnchor: NSLayoutXAxisAnchor { return target.leadingAnchor }
    public var trailingAnchor: NSLayoutXAxisAnchor { return target.trailingAnchor }
    public var centerXAnchor: NSLayoutXAxisAnchor { return target.centerXAnchor }
    public var centerYAnchor: NSLayoutYAxisAnchor { return target.centerYAnchor }
    public var widthAnchor: NSLayoutDimension { return target.widthAnchor }
    public var heightAnchor: NSLayoutDimension { return target.heightAnchor }

    @discardableResult
    public func prepareForLayout() -> Self { return LayoutsWraper(target: target.prepareForLayout()) }

    @discardableResult
    public func center(in view: TNConstrainable,
                       offset: CGPoint = .zero,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> [NSLayoutConstraint] {
        return target.center(in: view, offset: offset, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func edges(to view: TNConstrainable,
                      insets: UIEdgeInsets = .zero,
                      priority: UILayoutPriority = .required,
                      isActive: Bool = true) -> [NSLayoutConstraint] {
        return target.edges(to: view, insets: insets, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func size(_ size: CGSize, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        return target.size(size, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func size(to view: TNConstrainable,
                     multiplier: CGFloat = 1,
                     insets: CGSize = .zero,
                     relation: CommonNameSpace.ConstraintRelation = .equal,
                     priority: UILayoutPriority = .required,
                     isActive: Bool = true) -> [NSLayoutConstraint] {
        return target.size(to: view, multiplier: multiplier, insets: insets, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func origin(to view: TNConstrainable,
                       insets: UIEdgeInsets = .zero,
                       relation: CommonNameSpace.ConstraintRelation = .equal,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> [NSLayoutConstraint] {
        return target.origin(to: view, insets: insets, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func width(_ width: CGFloat,
                      relation: CommonNameSpace.ConstraintRelation = .equal,
                      priority: UILayoutPriority = .required,
                      isActive: Bool = true) -> NSLayoutConstraint {
        return target.width(width, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func width(to view: TNConstrainable,
                      _ dimension: NSLayoutDimension? = nil,
                      multiplier: CGFloat = 1,
                      offset: CGFloat = 0,
                      relation: CommonNameSpace.ConstraintRelation = .equal,
                      priority: UILayoutPriority = .required,
                      isActive: Bool = true) -> NSLayoutConstraint {
        return target.width(to: view, dimension, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func widthToHeight(of view: TNConstrainable,
                              multiplier: CGFloat = 1,
                              offset: CGFloat = 0,
                              relation: CommonNameSpace.ConstraintRelation = .equal,
                              priority: UILayoutPriority = .required,
                              isActive: Bool = true) -> NSLayoutConstraint {
        return target.widthToHeight(of: view, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func width(min: CGFloat? = nil,
                      max: CGFloat? = nil,
                      priority: UILayoutPriority = .required,
                      isActive: Bool = true) -> [NSLayoutConstraint] {
        return target.width(min: min, max: max, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func height(_ height: CGFloat,
                       relation: CommonNameSpace.ConstraintRelation = .equal,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        return target.height(height, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func height(to view: TNConstrainable,
                       _ dimension: NSLayoutDimension? = nil,
                       multiplier: CGFloat = 1,
                       offset: CGFloat = 0,
                       relation: CommonNameSpace.ConstraintRelation = .equal,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        return target.height(to: view, dimension, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func heightToWidth(of view: TNConstrainable,
                              multiplier: CGFloat = 1,
                              offset: CGFloat = 0,
                              relation: CommonNameSpace.ConstraintRelation = .equal,
                              priority: UILayoutPriority = .required,
                              isActive: Bool = true) -> NSLayoutConstraint {
        return target.heightToWidth(of: view, multiplier: multiplier, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func height(min: CGFloat? = nil,
                       max: CGFloat? = nil,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> [NSLayoutConstraint] {
        return target.height(min: min, max: max, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func aspectRatio(_ ratio: CGFloat,
                            relation: CommonNameSpace.ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true) -> NSLayoutConstraint {
        return target.aspectRatio(ratio, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func leadingToTrailing(of view: TNConstrainable,
                                  offset: CGFloat = 0,
                                  relation: CommonNameSpace.ConstraintRelation = .equal,
                                  priority: UILayoutPriority = .required,
                                  isActive: Bool = true) -> NSLayoutConstraint {
        return target.leadingToTrailing(of: view, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func leading(to view: TNConstrainable,
                        _ anchor: NSLayoutXAxisAnchor? = nil,
                        offset: CGFloat = 0,
                        relation: CommonNameSpace.ConstraintRelation = .equal,
                        priority: UILayoutPriority = .required,
                        isActive: Bool = true) -> NSLayoutConstraint {
        return target.leading(to: view, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func leftToRight(of view: TNConstrainable,
                            offset: CGFloat = 0,
                            relation: CommonNameSpace.ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true) -> NSLayoutConstraint {
        return target.leftToRight(of: view, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func left(to view: TNConstrainable,
                     _ anchor: NSLayoutXAxisAnchor? = nil,
                     offset: CGFloat = 0,
                     relation: CommonNameSpace.ConstraintRelation = .equal,
                     priority: UILayoutPriority = .required,
                     isActive: Bool = true) -> NSLayoutConstraint {
        return target.left(to: view, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func trailingToLeading(of view: TNConstrainable,
                                  offset: CGFloat = 0,
                                  relation: CommonNameSpace.ConstraintRelation = .equal,
                                  priority: UILayoutPriority = .required,
                                  isActive: Bool = true) -> NSLayoutConstraint {
        return target.trailingToLeading(of: view, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func trailing(to view: TNConstrainable,
                         _ anchor: NSLayoutXAxisAnchor? = nil,
                         offset: CGFloat = 0,
                         relation: CommonNameSpace.ConstraintRelation = .equal,
                         priority: UILayoutPriority = .required,
                         isActive: Bool = true) -> NSLayoutConstraint {
        return target.trailing(to: view, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func rightToLeft(of view: TNConstrainable,
                            offset: CGFloat = 0,
                            relation: CommonNameSpace.ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true) -> NSLayoutConstraint {
        return target.rightToLeft(of: view, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func right(to view: TNConstrainable,
                      _ anchor: NSLayoutXAxisAnchor? = nil,
                      offset: CGFloat = 0,
                      relation: CommonNameSpace.ConstraintRelation = .equal,
                      priority: UILayoutPriority = .required,
                      isActive: Bool = true) -> NSLayoutConstraint {
        return target.right(to: view, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func topToBottom(of view: TNConstrainable,
                            offset: CGFloat = 0,
                            relation: CommonNameSpace.ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true) -> NSLayoutConstraint {
        return target.topToBottom(of: view, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func top(to view: TNConstrainable,
                    _ anchor: NSLayoutYAxisAnchor? = nil,
                    offset: CGFloat = 0,
                    relation: CommonNameSpace.ConstraintRelation = .equal,
                    priority: UILayoutPriority = .required,
                    isActive: Bool = true) -> NSLayoutConstraint {
        return target.top(to: view, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func bottomToTop(of view: TNConstrainable,
                            offset: CGFloat = 0,
                            relation: CommonNameSpace.ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            isActive: Bool = true) -> NSLayoutConstraint {
        return target.bottomToTop(of: view, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func bottom(to view: TNConstrainable,
                       _ anchor: NSLayoutYAxisAnchor? = nil,
                       offset: CGFloat = 0,
                       relation: CommonNameSpace.ConstraintRelation = .equal,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> NSLayoutConstraint {
        return target.bottom(to: view, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func center(to view: TNConstrainable,
                       priority: UILayoutPriority = .required,
                       isActive: Bool = true) -> [NSLayoutConstraint] {
        return [
            centerX(to: view, nil, offset: 0, priority: priority, isActive: isActive),
            centerY(to: view, nil, offset: 0, priority: priority, isActive: isActive)
        ]
    }

    @discardableResult
    public func centerX(to view: TNConstrainable,
                        _ anchor: NSLayoutXAxisAnchor? = nil,
                        offset: CGFloat = 0,
                        priority: UILayoutPriority = .required,
                        isActive: Bool = true) -> NSLayoutConstraint {
        return target.centerX(to: view, anchor, offset: offset, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func centerY(to view: TNConstrainable,
                        _ anchor: NSLayoutYAxisAnchor? = nil,
                        offset: CGFloat = 0,
                        priority: UILayoutPriority = .required,
                        isActive: Bool = true) -> NSLayoutConstraint {
        return target.centerY(to: view, anchor, offset: offset, priority: priority, isActive: isActive)
    }
}

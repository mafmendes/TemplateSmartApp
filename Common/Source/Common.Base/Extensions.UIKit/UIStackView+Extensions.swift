//
//  Created by Ricardo Santos on 22/06/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// swiftlint:disable logs_rule_1

public extension CommonExtension where Target == UIStackView {
    
    func addCentered(any: Any, _ size: CGSize) { target.addCentered(any: any, size) }
    func add(any: Any) { target.add(any: any) }

    func addCentered(uiview: UIView, _ size: CGSize) { target.addCentered(any: uiview, size) }
    func add(uiview: UIView) { target.add(uiview: uiview) }

    func addCentered(anyview: AnyView, _ size: CGSize) { target.addCentered(any: anyview, size) }
    func add<Content>(view: Content) where Content: View { target.add(view: view) }

    func insertArrangedSubview(_ view: UIView, belowArrangedSubview subview: UIView) { target.insertArrangedSubview(view, belowArrangedSubview: subview) }
    func insertArrangedSubview(_ view: UIView, aboveArrangedSubview subview: UIView) { target.insertArrangedSubview(view, aboveArrangedSubview: subview) }
    func removeAllArrangedSubviews() { target.removeAllArrangedSubviews() }
    func edgeStackViewToSuperView(insets: UIEdgeInsets = .zero) { target.edgeStackViewToSuperView(insets: insets) }
    func addSeparator(color: UIColor = UIColor.darkGray, size: CGFloat = 3) { target.addSeparator(color: color, size: size) }
}

public extension UIStackView {
    var view: UIView { (self as UIView) }
}

public extension UIStackView {
    
    static func defaultVerticalStackView(_ defaultMargin: CGFloat = 16, _ spacing: CGFloat = 5) -> UIStackView {
        var layoutMargins: UIEdgeInsets {
            let topAndBottomSpacing: CGFloat = 0
            return UIEdgeInsets(top: topAndBottomSpacing,
                                left: defaultMargin,
                                bottom: topAndBottomSpacing,
                                right: defaultMargin)
        }

        let some = UIStackView()
        some.isLayoutMarginsRelativeArrangement = true
        some.axis         = .vertical
        some.distribution = .fill
        some.spacing      = spacing
        some.alignment    = .fill
        some.autoresizesSubviews = false
        some.layoutMargins = layoutMargins
        return some
    }
    
    static func defaultHorizontalStackView(_ defaultMargin: CGFloat = 16, _ spacing: CGFloat = 5) -> UIStackView {
        var layoutMargins: UIEdgeInsets {
            let topAndBottomSpacing: CGFloat = 0
            return UIEdgeInsets(top: topAndBottomSpacing,
                                left: defaultMargin,
                                bottom: topAndBottomSpacing,
                                right: defaultMargin)
        }

        let some = UIStackView()
        some.isLayoutMarginsRelativeArrangement = true
        some.axis         = .horizontal
        some.spacing      = spacing
        some.distribution = .equalCentering
        some.alignment = .center
        some.autoresizesSubviews = false
        some.layoutMargins = layoutMargins
        return some
    }
}

fileprivate extension UIStackView {

    func addSeparator(color: UIColor = UIColor.darkGray, size: CGFloat = 3) {
        let separator = UIView()
        separator.backgroundColor = color
        common.add(uiview: separator)
        separator.heightAnchor.constraint(equalToConstant: size).isActive = true
    }

    func edgeStackViewToSuperView(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        layouts.edgesToSuperview(insets: insets) // Don't use RJPSLayouts. It will fail if scroll view is inside of stack view with lots of elements
        layouts.width(to: superview) // NEEDS THIS!
    }
    
    func addCentered(any: Any, _ size: CGSize) {
        if let view = any as? UIView {
            let container = UIView()
            container.addSubview(view)
            view.layouts.centerToSuperview()
            view.layouts.size(size)
            container.layouts.height(size.height)
            add(uiview: container)
        } else if let view = any as? AnyView {
            return addCentered(any: view, size)
        }
    }
    
    func add(any: Any) {
        if let uiView = any as? UIView {
            add(uiview: uiView)
        } else if let view = any as? AnyView {
            add(view: view)
        } else {
            Common_Logs.error("Not predicted for [\(any)]")
        }
    }

    func add<Content>(view: Content) where Content: View {
        if let uiView = view.asViewController.view {
            add(uiview: uiView)
        }
    }

    func add(uiview: UIView) {
        if uiview.superview == nil {
            addArrangedSubview(uiview)
            uiview.setNeedsLayout()
            uiview.layoutIfNeeded()
        }
    }

    func insertArrangedSubview(_ view: UIView, belowArrangedSubview subview: UIView) {
        arrangedSubviews.enumerated().forEach {
            if $0.1 == subview {
                insertArrangedSubview(view, at: $0.0 + 1)
            }
        }
    }

    func insertArrangedSubview(_ view: UIView, aboveArrangedSubview subview: UIView) {
        arrangedSubviews.enumerated().forEach {
            if $0.1 == subview {
                insertArrangedSubview(view, at: $0.0)
            }
        }
    }

    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviewsRecursive, subview) -> [UIView] in
            removeArrangedSubview(subview)
            return allSubviewsRecursive + [subview]
        }
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({
            $0.constraints
        }))
        // Remove the views from self
        removedSubviews.forEach({
            $0.removeFromSuperview()
        })
    }
}

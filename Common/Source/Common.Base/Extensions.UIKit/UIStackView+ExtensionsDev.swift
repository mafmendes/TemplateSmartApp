//
//  Created by Ricardo Santos on 22/06/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// swiftlint:disable logs_rule_1 no_UIKitAdhocConstruction random_rule_2

public extension UIStackView {
    
    private static func captionDefaultFont() -> UIFont { .systemFont(ofSize: 15) }
    private static func titleDefaultFont() -> UIFont { .boldSystemFont(ofSize: 20) }
    static func fontDefaultColor() -> UIColor {
        UIColor.label
//        UIView().traitCollection.userInterfaceStyle == .dark ? UIColor.colorFromRGBString("0,0,0") : UIColor.colorFromRGBString("255,255,255")
    }
    
    private func dev_private_add(view: UIView, caption: String, size: CGSize? = nil, centered: Bool) {
        
        func add(views: [UIView], _ caption: String) {
            dev_add(caption: caption)
            if views.count == 1 {
                common.add(any: views.first as Any)
            } else {
                let stackView = UIStackView.defaultHorizontalStackView()
                views.forEach { (some) in
                    stackView.common.add(any: some)
                }
                common.add(any: stackView)
            }
        }
        
        if centered {
            add(views: [UIView(), view, UIView()], caption)
        } else {
            add(views: [view], caption)
        }
        if let size = size {
            view.layouts.size(size)
        }
        if let backgroundColor = backgroundColor {
            view.backgroundColor = backgroundColor
        }
    }
    
    func dev_addHorizontalView(_ view: () -> UIView,
                               _ caption: String,
                               _ size: CGSize? = nil,
                               _ backgroundColor: UIColor? = nil,
                               _ centered: Bool) {
        var shortCaption = caption
        if shortCaption.contains("_") {
            shortCaption = shortCaption.split(by: "_").last!
        }
        let viewLigth = view()
        let viewDark = view()
        viewLigth.overrideUserInterfaceStyle = .light
        viewDark.overrideUserInterfaceStyle = .dark
        dev_private_add(view: viewLigth, caption: "\(shortCaption) (light)", size: size, centered: centered)
        dev_private_add(view: viewDark, caption: "\(shortCaption) (dark)", size: size, centered: centered)
    }
    
    func dev_add(caption: String) {
        let label = UILabel()
        label.text = caption
        label.font = Self.captionDefaultFont()
        label.textColor = UIStackView.fontDefaultColor()
        label.textAlignment = .center
        label.numberOfLines = 2
        let separator1 = UIView()
        let separator2 = UIView()
        separator1.backgroundColor = Self.fontDefaultColor().alpha(0.5)
        separator2.backgroundColor = UIColor.clear
        common.add(uiview: separator1)
        common.add(uiview: label)
        common.add(uiview: separator2)
        if caption.contains("\n") {
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        } else {
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        separator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator2.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    func dev_addSection(title: String) {
        let label = UILabel()
        label.text = title
        label.font = Self.titleDefaultFont()
        label.textColor = UIStackView.fontDefaultColor()
        label.textAlignment = .center
        let separator1 = UIView()
        let separator2 = UIView()
        let separator3 = UIView()
        separator1.backgroundColor = Self.fontDefaultColor().alpha(0.5)
        separator2.backgroundColor = UIColor.clear
        separator3.backgroundColor = UIColor.clear
        common.add(uiview: separator3)
        common.add(uiview: separator1)
        common.add(uiview: label)
        common.add(uiview: separator2)
        separator1.heightAnchor.constraint(equalToConstant: 3).isActive = true
        separator2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        separator3.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
}

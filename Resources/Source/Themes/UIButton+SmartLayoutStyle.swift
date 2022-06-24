//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import AppConstants

public extension UIButton {
    
    enum SmartLayoutStyle: String, CaseIterable {

        case notApplied
        case primary
        case secondary

        public typealias RawValue = String
        public init?(rawValue: RawValue) {
            if let some = Self.allCases.first(where: { $0.rawValue == rawValue }) {
                self = some
            } else {
                return nil
            }
        }
    }
}

public extension UIButton {

    // Cant be o Designables because the Designables allready import AppTheme
    static var defaultFont: UIFont { FontSemanticSmart.title2.rawValue }
    static var buttonDefaultSize: CGSize { return CGSize(width: 125, height: 44) }

    var layoutStyle: ButtontStyle {
        get { return .notApplied }
        set { apply(style: newValue) }
    }

    func setState(enabled: Bool) {
        isUserInteractionEnabled = enabled
        alpha = enabled ? 1.0 : 0.6
    }

    func apply(style: ButtontStyle) {
        switch style {
        case .notApplied  : _ = 1
        case .primary     : applyStylePrimary()
        case .secondary   : applyStyleSecondary()
        }
    }
}

private extension UIButton {

    // swiftlint:disable random_rule_2
    func applySharedProperties() {
        setState(enabled: true)
    }

    func applyStylePrimary() {
        applySharedProperties()
        titleLabel?.font = UIButton.defaultFont
        backgroundColor  = UIColor.darkGray
        layer.cornerRadius = UIButton.buttonDefaultSize.height / 2
        clipsToBounds      = true
    }

    func applyStyleSecondary() {
        applySharedProperties()
        titleLabel?.font = UIButton.defaultFont
        backgroundColor  = UIColor.lightGray
        layer.borderWidth  = 2
        layer.cornerRadius = UIButton.buttonDefaultSize.height / 2
        clipsToBounds      = true
    }
    // swiftlint:enable random_rule_2
}

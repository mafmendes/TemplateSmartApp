//
// Created by Zé on 09/12/20.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UIView {
    func enableVoiceOver() { target.enableVoiceOver() }
    func disableVoiceOver() { target.disableVoiceOver() }

    var voiceOver: String { target.voiceOver }
    var voiceOverHint: String { target.voiceOverHint }
    var voiceOverIsEnabled: Bool { target.voiceOverIsEnabled }

    func setupAccessibilityWith(voiceOver: String, voiceOverHint: String = "") {
        target.setupAccessibilityWith(voiceOver: voiceOver, voiceOverHint: voiceOverHint)
    }
}

public extension CommonExtension where Target == UIBarButtonItem {
    var voiceOver: String { target.voiceOver }
    var voiceOverHint: String { target.voiceOverHint }
    var voiceOverIsEnabled: Bool { target.voiceOverIsEnabled }
}

public extension UIView {
    func enableVoiceOver() {
        accessibilityElementsHidden = false
    }

    func disableVoiceOver() {
        accessibilityElementsHidden = true
    }

    var voiceOver: String {
        get { accessibilityLabel ?? "" }
        set { if !newValue.isEmpty { accessibilityLabel = newValue } }
    }

    var voiceOverHint: String {
        get { accessibilityHint ?? "" }
        set { accessibilityHint = newValue }
    }

    var voiceOverIsEnabled: Bool {
        get { isAccessibilityElement }
        set { isAccessibilityElement = newValue }
    }

    func setupAccessibilityWith(voiceOver: String, voiceOverHint: String = "") {
        self.voiceOver = voiceOver
        self.voiceOverHint = voiceOverHint
        if let btn = self as? UIButton { btn.accessibilityTraits = .button }
        if let lbl = self as? UILabel { lbl.accessibilityTraits = .staticText }
    }
}

public extension UIBarButtonItem {
    var voiceOver: String {
        get { accessibilityLabel ?? "" }
        set { if !newValue.isEmpty { self.accessibilityLabel = newValue } }
    }

    var voiceOverHint: String {
        get { accessibilityHint ?? "" }
        set { accessibilityHint = newValue }
    }

    var voiceOverIsEnabled: Bool {
        get { isAccessibilityElement }
        set { isAccessibilityElement = newValue }
    }
}

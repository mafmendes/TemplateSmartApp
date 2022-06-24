//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UIButton {
    func disable() { target.disable() }
    func doTouchUpInside() { target.doTouchUpInside() }
    func onTouchUpInside(autoDisableUserInteractionFor: Double=1, block: @escaping () -> Void) {
        target.onTouchUpInside(autoDisableUserInteractionFor: autoDisableUserInteractionFor, block: block)
    }
    func enable() { target.enable() }

    func paintImage(with color: UIColor) { target.paintImage(with: color) }
    func changeImageColor(to color: UIColor) { target.changeImageColor(to: color) }

    func setImageForAllStates(_ image: UIImage, tintColor: UIColor?) { target.setImageForAllStates(image, tintColor: tintColor) }
    func setTitleForAllStates(_ title: String) { target.setTitleForAllStates(title) }
    func setTextColorForAllStates(_ color: UIColor) { target.setTextColorForAllStates(color) }
}

public extension UIButton {

    /// Will simulate user touch
    func doTouchUpInside() {
        sendActions(for: .touchUpInside)
    }

    func paintImage(with color: UIColor) {
        changeImageColor(to: color)
    }

    /// Turn image into template image, and apply color
    func changeImageColor(to color: UIColor) {
        guard let origImage = image(for: state) else { return }
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        setImageForAllStates(tintedImage, tintColor: color)
        tintColor = color
    }

    func setImageForAllStates(_ image: UIImage, tintColor: UIColor?) {
        let tintedImage = (tintColor != nil) ? image.withRenderingMode(.alwaysTemplate) : image
        setImage(tintedImage, for: .normal)
        setImage(tintedImage, for: .disabled)
        setImage(tintedImage, for: .highlighted)
        setImage(tintedImage, for: .focused)
        if tintColor != nil {
            self.tintColor = tintColor
        }
    }

    func disable() {
        isUserInteractionEnabled = false
        fadeTo(0.6)
    }

    func enable() {
        isUserInteractionEnabled = true
        fadeTo(1)
    }

    func setTitleForAllStates(_ title: String) {
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .selected)
    }

    func setTextColorForAllStates(_ color: UIColor) {
        titleLabel?.textColor = color
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
        setTitleColor(color, for: .selected)
    }

    func onTouchUpInside(autoDisableUserInteractionFor: Double=1, block:@escaping () -> Void) {

        class ClosureSleeve {
            let block: () -> Void
            init (_ block: @escaping () -> Void) {
                self.block = block
            }
            @objc func invoke () { block() }
        }

        (self as UIView).common.disableUserInteractionFor(autoDisableUserInteractionFor)
        let sleeve = ClosureSleeve(block)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: .touchUpInside)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
    }

    func bumpAndPerform(scale: CGFloat = 1.05,
                        disableUserInteractionFor: Double = 1,
                        block:@escaping () -> Void) {
        (self as UIView).common.disableUserInteractionFor(disableUserInteractionFor)
        UIView.animate(withDuration: Common_Constants.defaultAnimationsTime/2.0, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: scale, y: scale) },
                       completion: { _ in
                        UIView.animate(withDuration: Common_Constants.defaultAnimationsTime/2.0 ,
                                       animations: { self.transform = .identity },
                                       completion: { _ in
                                        block()
                        })
        })
    }
}

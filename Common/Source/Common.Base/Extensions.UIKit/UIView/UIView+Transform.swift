//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

///////////// UTILS DEV /////////////

public extension CommonExtension where Target == UIView {
    func addCorner(radius: CGFloat) { target.addCorner(radius: radius) }
    func addCornerCurve(method: CALayerCornerCurve, radius: CGFloat) { target.addCornerCurve(method: method, radius: radius) }
    func addCornerShape(corners: UIRectCorner, radius: CGFloat) { target.addCornerShape(corners: corners, radius: radius) }
    func addBorder(width: CGFloat, color: UIColor, animated: Bool) { target.addBorder(width: width, color: color, animated: animated) }
    func addBlur(style: UIBlurEffect.Style = .dark) -> UIVisualEffectView { target.addBlur(style: style) }
    func fadeTo(_ value: CGFloat, duration: Double=Common_Constants.defaultAnimationsTime) { target.fadeTo(value, duration: duration) }
}

public extension UIView {
    
    func animateBorderWidth(toValue: CGFloat, duration: Double) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = layer.borderWidth
        animation.toValue = toValue
        animation.duration = duration
        layer.add(animation, forKey: "Width")
        layer.borderWidth = toValue
    }
    
    func animateBorderColor(toValue: UIColor, duration: Double) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toValue.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toValue.cgColor
    }
    
    func addBorder(width: CGFloat, color: UIColor, animated: Bool) {
        if !animated {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
            clipsToBounds     = true
        } else {
            animateBorderColor(toValue: color, duration: Common_Constants.defaultAnimationsTime)
            animateBorderWidth(toValue: width, duration: Common_Constants.defaultAnimationsTime)
        }
    }
    
    func addCornerShape(corners: UIRectCorner = [.topLeft, .topRight], radius: CGFloat = 34) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.shouldRasterize = true
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addCornerCurve(method: CALayerCornerCurve = .circular, radius: CGFloat = 34) {
        layer.cornerCurve = method // .continuous | .circular
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func addCorner(radius: CGFloat) {
        addCornerCurve(method: .circular, radius: radius)
    }
    
    // this functions is duplicated
    func addBlur(style: UIBlurEffect.Style = .dark) -> UIVisualEffectView {
        let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        addSubview(blurEffectView)
        return blurEffectView
    }
    
    func fadeTo(_ value: CGFloat, duration: Double=Common_Constants.defaultAnimationsTime) {
        Common_Utils.executeInMainTread { [weak self] in
            UIView.animate(withDuration: duration) { [weak self] in
                self?.alpha = value
            }
        }
    }
    
}

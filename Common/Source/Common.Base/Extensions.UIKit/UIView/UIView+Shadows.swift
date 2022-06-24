//
//  Created by Ricardo Santos on 20/01/2021.
//

import Foundation
import UIKit
//
public extension CommonExtension where Target == UIView {

    func addDropShadow(color: UIColor = UIView.defaultShadowColor, shadowType: App_ShadowStrength = .heavy) {
        target.addDropShadow(color: color, shadowType: shadowType)
    }

    func addShadow(color: UIColor = UIView.defaultShadowColor,
                   offset: CGSize = UIView.defaultShadowOffset,
                   radius: CGFloat = UIView.defaultShadowOffset.height,
                   strength: App_ShadowStrength = .superLight) {
        target.addShadow(color: color, offset: offset, radius: radius, strength: strength)
    }

    func addShadowSketch(color: UIColor = .black,
                         alpha: Float = 0.5,
                         x: CGFloat = 0,
                         y: CGFloat = 2,
                         radius: CGFloat = 4,
                         spread: CGFloat = 0) {
        target.layer.addShadowSketch(color: color, alpha: alpha, x: x, y: y, radius: radius, spread: spread)
    }
}

public extension UIView {

    static var defaultShadowColor = UIColor(red: CGFloat(80/255.0), green: CGFloat(88/255.0), blue: CGFloat(93/255.0), alpha: 1)
    static let defaultShadowOffset = CGSize(width: 1, height: 5) // Shadow bellow

    func addDropShadow(color: UIColor = UIView.defaultShadowColor, shadowType: App_ShadowStrength = .heavy) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = Float(shadowType.rawValue)
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 5
        layer.shouldRasterize = true
    }

    //
    // More about shadows : https://medium.com/swlh/how-to-create-advanced-shadows-in-swift-ios-swift-guide-9d2844b653f8
    //

    func addShadow(color: UIColor = defaultShadowColor,
                   offset: CGSize = defaultShadowOffset,
                   radius: CGFloat = defaultShadowOffset.height,
                   strength: App_ShadowStrength = .superLight) {
        layer.shadowColor   = color.cgColor
        layer.shadowOpacity = Float(1 - strength.rawValue)
        layer.shadowOffset  = offset
        layer.shadowRadius  = radius
        layer.masksToBounds = false
        layer.shouldRasterize = true
    }
}

public extension CALayer {
    // Extension from: https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur
    func addShadowSketch(color: UIColor = UIView.defaultShadowColor,
                         alpha: Float = 0.5,
                         x: CGFloat = 0,
                         y: CGFloat = 2,
                         radius: CGFloat = 4,
                         spread: CGFloat = 0) {
                
        // Optimize 1 : Ask iOS to cache the rendered shadow so that it doesn't need to be redrawn:
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
        
        // Optimize 2: set the shadowPath property to a specific value so that iOS doesn't need to calculate transparency dynamically.
        // For example, this creates a shadow path equivalent to the frame of the view:
        shadowPath = UIBezierPath(rect: self.bounds).cgPath

        // Add Shadow
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = radius
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

}

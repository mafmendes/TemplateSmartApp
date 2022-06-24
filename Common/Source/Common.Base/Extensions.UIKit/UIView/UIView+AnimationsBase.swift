//
//  Created by Ricardo Santos on 07/03/2021.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UIView {
    func shake() { target.shake() }
}

//
// Hide the implementation and force the use of the `rjs` alias
//

fileprivate extension UIView {
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
}

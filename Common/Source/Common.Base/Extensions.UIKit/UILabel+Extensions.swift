//
//  Created by Ricardo Santos on 06/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UILabel {
    var textAnimated: String? {
        get { target.text }
        set { target.textAnimated = newValue }
    }
}

public extension UILabel {
    var textAnimated: String? {
        get { return text }
        set { fadeTransition(); text = newValue ?? "" }
    }
}

fileprivate extension UILabel {
    func fadeTransition(_ duration: CFTimeInterval=0.5) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type           = .fade
        animation.duration       = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

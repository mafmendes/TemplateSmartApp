//
//  Created by Santos, Ricardo Patricio dos  on 04/05/2021.
//

import Foundation
import UIKit

private var isPerformingSnapAnimation = false

/// Given `source: Any?` will return the value for the property named `property: String`
public func mirrorValueFor(property: String, source: Any?) -> String? {
    guard let source = source else {
        return nil
    }
    guard let value = Mirror(reflecting: source)
            .children
            .filter({ $0.label == property })
            .first?.value else {
        return nil
    }
    let result = "\(value)"
    return result
}

public func snapAnimation(animated: Bool,
                          animationId: String,
                          withDuration: Double = 0.3,
                          usingSpringWithDamping: CGFloat = 30,
                          initialSpringVelocity: CGFloat = 1,
                          block: @escaping () -> Void,
                          completed: @escaping () -> Void) {
    guard !isPerformingSnapAnimation else {
        return
    }
    if animated {
        isPerformingSnapAnimation = true
        UIView.animate(withDuration: withDuration,
                       delay: 0,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: .curveEaseOut,
                       animations: {
                        block()
                       }) { _ in
            isPerformingSnapAnimation = false
            completed()
        }
    } else {
        block()
        completed()
    }
}

/// Same animation as `snapAnimation` but with no lock if performing animation
public func snapAnimationUnblocked(animated: Bool,
                                   withDuration: Double = 0.3,
                                   usingSpringWithDamping: CGFloat = 30,
                                   initialSpringVelocity: CGFloat = 1,
                                   block: @escaping () -> Void,
                                   completed: @escaping () -> Void) {
    if animated {
        UIView.animate(withDuration: withDuration,
                       delay: 0,
                       usingSpringWithDamping: usingSpringWithDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: .curveEaseOut, animations: {
                        block()
                       }) { _ in
            completed()
        }
    } else {
        block()
        completed()
    }
}

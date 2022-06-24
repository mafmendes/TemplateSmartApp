//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
//
import DevTools

extension UIStackView {

    func edgeStackViewToSuperView() {
        guard self.superview != nil else {
            DevTools.Log.error("\(Self.self) - edgeStackViewToSuperView : No super view for [\(self)]", .generic)
            return
        }
        self.layouts.edgesToSuperview() // Don't use RJPSLayouts. It will fail if scroll view is inside of stack view with lots of elements
        self.layouts.width(to: superview!) // NEEDS THIS!
    }

    @discardableResult
    func addSeparator(withSize value: CGFloat=0, color: UIColor = .clear, tag: Int? = nil) -> UIView {
        let separator = UIView()
        separator.backgroundColor = color
        if tag != nil {
            separator.tag = tag!
        }
        self.addArrangedSubview(separator)
        var finalValue = value
        if finalValue == 0 && self.spacing == 0 {
            // No space passed, and the stack view does not have space? Lets force a space
            finalValue = 10
        }
        if self.axis == .horizontal {
            separator.layouts.width(finalValue)
        } else {
            separator.layouts.height(finalValue)
        }
        return separator
    }
}

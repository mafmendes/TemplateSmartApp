//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation

public enum UIKitViewFactoryElementTag: Int {
    // Simple
    case view = 1000
    case button
    case scrollView
    case stackView
    case imageView
    case textField
    case searchBar
    case label
    case tableView
    case `switch`
    case stackViewSpace

    // Component
    case reachabilityView

    // Composed
    case switchWithCaption
    case genericTitleAndValue
}

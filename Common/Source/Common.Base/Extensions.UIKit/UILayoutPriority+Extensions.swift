//
//  Created by Ricardo Santos on 20/02/2021.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UILayoutPriority {
    static var almostRequired: UILayoutPriority { UILayoutPriority.almostRequired }
    static var superHigh: UILayoutPriority { UILayoutPriority.superHigh }
    static var high: UILayoutPriority { UILayoutPriority.high }
    static var mediumHigh: UILayoutPriority { UILayoutPriority.mediumHigh }
    static var medium: UILayoutPriority { UILayoutPriority.medium }
    static var mediumLow: UILayoutPriority { UILayoutPriority.mediumLow }
    static var superLow: UILayoutPriority { UILayoutPriority.superLow }
    static var almostNotRequired: UILayoutPriority { UILayoutPriority.almostNotRequired }
}

public extension UILayoutPriority {

    /// Creates a priority which is almost required, but not 100%.
    static var almostRequired: UILayoutPriority {
        UILayoutPriority(rawValue: 999)
    }

    static var superHigh: UILayoutPriority {
        UILayoutPriority(rawValue: 500 * 1.9)
    }
    
    static var high: UILayoutPriority {
        UILayoutPriority(rawValue: 500 * 1.75)
    }
    
    static var mediumHigh: UILayoutPriority {
        UILayoutPriority(rawValue: 500 * 1.5)
    }
    
    static var medium: UILayoutPriority {
        UILayoutPriority(rawValue: 500)
    }

    static var mediumLow: UILayoutPriority {
        UILayoutPriority(rawValue: 500 * 0.5)
    }
    
    static var low: UILayoutPriority {
        UILayoutPriority(rawValue: 500 * 0.25)
    }
    
    static var superLow: UILayoutPriority {
        UILayoutPriority(rawValue: 500 * 0.1)
    }
    
    static var almostNotRequired: UILayoutPriority {
        UILayoutPriority(rawValue: 1)
    }
}

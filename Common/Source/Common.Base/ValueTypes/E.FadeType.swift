//
//  Created by Ricardo Santos on 17/01/2021.
//

import Foundation
import UIKit

public enum FilterStrength: CGFloat, CaseIterable {
    case none         = 1
    case superLight   = 0.95
    case regular      = 0.75
    case heavyRegular = 0.6
    case almostHeavy  = 0.3
    case heavy        = 0.4
    case superHeavy   = 0.1
}

public extension App_FadeType {
    static var disabledUIElementDefaultValue: App_FilterStrength {
        return heavyRegular
    }
}

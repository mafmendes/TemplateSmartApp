//
//  Created by Santos, Ricardo Patricio dos  on 07/07/2021.
//

import Foundation
import UIKit
//
import Common

public extension CGFloat {
        
    var localeString: String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.isLenient = true
        return formatter.string(from: self as NSNumber) ?? "\(self)"
    }
}

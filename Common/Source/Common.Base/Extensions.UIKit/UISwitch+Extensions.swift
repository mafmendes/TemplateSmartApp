//
//  Created by Ricardo Santos on 25/02/2021.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UISwitch {
    func doTouchUpInside() { target.doTouchUpInside() }
}

public extension UISwitch {
    /// Will simulate user touch
    func doTouchUpInside() {
        sendActions(for: .valueChanged)
    }
}

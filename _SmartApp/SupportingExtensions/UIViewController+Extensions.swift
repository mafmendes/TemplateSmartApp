//
//  Created by Santos, Ricardo Patricio dos  on 24/04/2021.
//

import Foundation
import UIKit
//
import BaseUI
import Resources
import AppConstants
public extension UIViewController {
    func doViewWillFirstAppear() {
        (self as? BaseViewController)?.viewWillFirstAppear()
    }
}

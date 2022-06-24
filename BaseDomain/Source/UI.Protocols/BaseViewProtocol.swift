//
//  Created by Ricardo Santos on 21/01/2021.
//

import Foundation
import UIKit
//
import Common
import AppConstants

public protocol BaseViewProtocol: AnyObject {
    func displayMessage(title: String, _ message: String, type: AlertType, actions: [CommonNameSpace.AlertAction])
}

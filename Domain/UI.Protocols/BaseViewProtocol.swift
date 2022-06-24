//
//  Created by Ricardo Santos on 21/01/2021.
//

import Foundation
import UIKit

public protocol BaseViewProtocol: AnyObject {
    func displayMessage(_ message: String, type: AlertType)
}

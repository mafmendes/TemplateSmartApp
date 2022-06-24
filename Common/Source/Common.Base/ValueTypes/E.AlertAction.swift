//
//  Created by Ricardo Santos on 10/03/2021.
//

import Foundation
import UIKit

public extension CommonNameSpace {
    struct AlertAction {
        public let title: String
        public let style: UIAlertAction.Style
        public let action: (() -> Void)?
        
        public init(title: String, style: UIAlertAction.Style, action: (() -> Void)?) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
}

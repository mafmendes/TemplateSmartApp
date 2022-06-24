//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UIViewController {
    var topViewController: UIViewController? { target.topViewController }

    static var topViewController: UIViewController? { UIViewController.topViewController }

    var isVisible: Bool { target.isVisible }

    var genericAccessibilityIdentifier: String { target.genericAccessibilityIdentifier }

}

public extension UIViewController {

    var topViewController: UIViewController? {
        return UIViewController.topViewController
    }

    static var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }

    var isVisible: Bool { return isViewLoaded && (view.window != nil) }

    var genericAccessibilityIdentifier: String {
        // One day we will have Accessibility on the app, and we will be ready....
        let name = String(describing: type(of: self))
        return "accessibilityIdentifierPrefix.\(name)"
    }
}

//
//  Created by Ricardo Santos on 10/03/2021.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UIWindow {
    static var new: UIWindow { Target.new }

    static func newWith(viewController: UIViewController) -> UIWindow { UIWindow.newWith(viewController: viewController) }
}

public extension UIWindow {
    static var new: UIWindow {
        UIWindow.newWith(viewController: UIViewController())
    }

    static func newWith(viewController: UIViewController) -> UIWindow {
        let new = UIWindow(frame: UIScreen.main.bounds)
        new.windowLevel = .alert
        new.rootViewController = viewController
        new.rootViewController?.view.backgroundColor = .clear
        new.backgroundColor = .clear
        new.makeKeyAndVisible()
        return new
    }
}

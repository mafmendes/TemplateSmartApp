//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public typealias RJS_PresentedController = (UIViewController?, NSError?) -> Void
public typealias RJS_LoadedController    = (UIViewController?, NSError?) -> Void

public extension CommonExtension where Target == UIViewController {
    func showAlert(title: String="Alert", message: String) { target.showAlert(title: title, message: message) }
    func dismissMe() { target.dismissMe() }
    func dismissAll() { target.dismissAll() }
    func destroy() { target.destroy() }
    var isDarkMode: Bool { target.isDarkMode }
}

public extension UIViewController {

    //
    // UTILS
    //

    var isDarkMode: Bool {
        self.traitCollection.userInterfaceStyle == .dark
    }
    
    func embeddedInNavigationController() -> UINavigationController {
        assert(parent == nil, "Cannot embebed in a Navigation Controller. \(String(describing: self)) already has a parent controller.")
        let navController = UINavigationController(rootViewController: self)
        return navController
    }

    func dismissMe() { dismiss(options: 2)}
    func dismissAll() { dismiss(options: 1)}

    func destroy() {
        children.forEach({ (some) in
            some.destroy()
        })
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        NotificationCenter.default.removeObserver(self) // Remove from all notifications being observed
    }
    
    /// Param options = 1 : all view controllers
    /// Param options = 2 : self view controller
    func dismiss(options: Int, animated: Bool=true, completion: (() -> Void)? = nil) {
        if options == 1 {
            var presentingVC = presentingViewController
            while presentingVC?.presentingViewController != nil {
                presentingVC = presentingVC?.presentingViewController
            }
            presentingVC?.dismiss(animated: animated, completion: completion)
        } else {
            let navigationController = self.navigationController != nil
            if !navigationController {
                dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
        }
    }

    func showAlert(title: String="Alert",
                   message: String) {
        DispatchQueue.executeInMainTread {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    static func present(controller: UIViewController,
                        sender: UIViewController,
                        modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
                        loadedController:@escaping RJS_LoadedController = { _, _ in },
                        completion:@escaping RJS_PresentedController = { _, _ in }) {
        controller.modalTransitionStyle = modalTransitionStyle
        loadedController(controller, nil)
        sender.present(controller, animated: true, completion: {
            completion(controller, nil)
        })

    }

    static func loadViewControllerInContainedView(sender: UIViewController,
                                                  senderContainedView: UIView,
                                                  controller: UIViewController,
                                                  adjustFrame: Bool,
                                                  completion: RJS_PresentedController) {
        senderContainedView.removeAllSubviewsRecursive()
        controller.willMove(toParent: sender)
        senderContainedView.addSubview(controller.view)
        sender.addChild(controller)
        controller.didMove(toParent: sender)
        if adjustFrame {
            controller.view.frame = senderContainedView.bounds
        }
        completion(controller, nil)
    }

}

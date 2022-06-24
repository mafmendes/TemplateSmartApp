//
//  Created by Ricardo Santos on 10/03/2021.
//

import Foundation
import UIKit
import SwiftUI

public extension CommonExtension where Target == UIViewController {

    var asAnyView: AnyView { target.asAnyView }

    func showAlertWithActions(title: String,
                              message: String,
                              actions: [UIAlertAction],
                              animated: Bool = true) {
        target.showAlertWithActions(title: title,
                                    message: message,
                                    actions: actions,
                                    animated: true)
    }

    func alert(title: String?,
               message: String?,
               preferredStyle: UIAlertController.Style = .actionSheet,
               actions: [CommonNameSpace.AlertAction]) {
        if actions.count == 0 {
            showAlert(title: title ?? "", message: message ?? "")
        } else {
            target.alert(title: title,
                         message: message,
                         preferredStyle: preferredStyle,
                         actions: actions)
        }

    }

    func showOkAlert(title: String = "",
                     message: String,
                     actionTitle: String = "OK",
                     completion: (() -> Void)? = nil,
                     animated: Bool = true) {
        target.showOkAlert(title: title,
                           message: message,
                           actionTitle: actionTitle,
                           completion: completion,
                           animated: animated)

    }
}

public extension UIViewController {

    var printableMemoryAddress: String {
        // https://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
    
    var swiftUIView: AnyView { asAnyView }
    var asAnyView: AnyView { Common_ViewControllerRepresentable { self }.erased }

    func alert(title: String?,
               message: String?,
               preferredStyle: UIAlertController.Style = .alert,
               actions: [CommonNameSpace.AlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { item in
            let action = UIAlertAction(title: item.title, style: item.style) { _ in
                if let doAction = item.action {
                    doAction()
    
                }
            }
            alertController.addAction(action)
        }
        if actions.count == 0 {
            alertController.addAction(.ok)
        }
        Self.topViewController?.present(alertController, animated: true)
    }

    func showOkAlert(title: String = "",
                     message: String,
                     actionTitle: String = "OK",
                     completion: (() -> Void)? = nil, animated: Bool = true) {
        let okAction = UIAlertAction.ok(title: actionTitle, completion: { completion?() })
        showAlertWithActions(title: title, message: message, actions: [okAction], animated: animated)
    }

    func showAlertWithActions(title: String,
                              message: String,
                              actions: [UIAlertAction],
                              animated: Bool = true) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alert.addAction)
        present(alert, animated: animated)
    }
}

public extension UIAlertAction {
    static var ok: UIAlertAction {
        ok {}
    }

    static func ok(title: String = "OK", completion: @escaping () -> Void) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: { _ in completion() })
    }
}

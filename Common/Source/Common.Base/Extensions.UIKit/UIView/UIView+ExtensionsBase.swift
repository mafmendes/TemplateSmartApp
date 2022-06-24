//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public extension CommonExtension where Target == UIView {
    var asSwiftUIView: AnyView { asAnyView }
    var erased: AnyView { target.erased }
    var asAnyView: AnyView { target.asAnyView }
    var screenHeightSafe: CGFloat { target.screenHeightSafe }
    var width: CGFloat { target.width }
    var height: CGFloat { target.height }
    var asImage: UIImage { target.asImage }
    var printableMemoryAddress: String { target.printableMemoryAddress }
    var viewController: UIViewController? { target.viewController }
    var assocViewController: UIViewController? { target.viewController }
    func bringToFront() { target.bringToFront() }
    func sendToBack() { target.sendToBack() }
    func disableUserInteractionFor(_ seconds: Double, disableAlpha: CGFloat = 0.6) { target.disableUserInteractionFor(seconds, disableAlpha: disableAlpha) }
    func superview<T>(of type: T.Type) -> T? { target.superview(of: type) }
}

//
// Hide the implementation and force the use of the `rjs` alias
//

public extension UIView {
    func bringToFront() { superview?.bringSubviewToFront(self) }

    func sendToBack() { superview?.sendSubviewToBack(self) }
    
    var erased: AnyView {
        asAnyView
    }
}

fileprivate extension UIView {

    var screenHeightSafe: CGFloat {
        screenHeight - safeAreaInsets.bottom.magnitude - safeAreaInsets.top.magnitude
    }
    
    // Find super views of type
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }
    
    var asAnyView: AnyView {
        Common_ViewRepresentable { self }.erased
    }
    
    var asImage: UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }

        return image
    }

    var printableMemoryAddress: String {
        // https://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }

    var width: CGFloat { frame.width }
    var height: CGFloat { frame.height }

    var viewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        }
        if let nextResponder = next as? UIView {
            return nextResponder.viewController
        }
        return nil
    }

    func disableUserInteractionFor(_ seconds: Double, disableAlpha: CGFloat=1) {
        guard self.isUserInteractionEnabled else { return }
        guard seconds > 0 else { return }
        isUserInteractionEnabled = false
        alpha = disableAlpha
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(seconds)) { [weak self] in
            self?.isUserInteractionEnabled = true
            self?.alpha = 1
        }
    }

}

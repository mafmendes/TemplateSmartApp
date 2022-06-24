//
//  Created by Ricardo Santos on 14/02/2021.
//

import Foundation
import SwiftUI

//
// References:
// https://www.avanderlee.com/swiftui/integrating-swiftui-with-uikit/
//

public extension View {

    // SwiftUIView -> UIViewController
    var asViewController: UIViewController {
        UIHostingController(rootView: self)
    }

    // SwiftUIView -> UIView
    var uiView: UIView {
        asViewController.view
    }

    func loadInside(view: UIView) {
        view.loadWithSwiftUIView(self)
    }

    func loadInside(viewController: UIViewController) {
        viewController.addChildSwiftUIView(self)
    }
}

public extension UIView {

    func loadWithSwiftUIView<Content>(_ swiftUIView: Content) where Content: View {
        addSwiftUIView(swiftUIView)
    }

    func addSwiftUIView<Content>(_ swiftUIView: Content) where Content: View {
        if let view = swiftUIView.asViewController.view {
            addSubview(view)
            view.edgesToSuperview()
        }
    }
}

public extension UIViewController {

    /// Add a SwiftUI `View` as a child of the input `UIView`.
    /// - Parameters:
    ///   - swiftUIView: The SwiftUI `View` to add as a child.
    ///   - view: The `UIView` instance to which the view should be added.
    private func addSwiftUIView<Content>(_ swiftUIView: Content, to view: UIView) where Content: View {
        let hostingController = swiftUIView.asViewController
        if let newView = hostingController.view {

            // Add as a child of the current view controller.
            addChild(hostingController)

            // Add the SwiftUI view to the view controller view hierarchy.
            view.addSubview(newView)
            newView.layouts.edgesToSuperview()

            // Notify the hosting controller that it has been moved to the current view controller.
            hostingController.didMove(toParent: self)
        }
    }

    // Add Content inside a container
    func addChildSwiftUIView<Content>(_ swiftUIView: Content, into view: UIView) where Content: View {
        addSwiftUIView(swiftUIView, to: view)
    }

    // Add Content inside the UIViewController view
    func addChildSwiftUIView<Content>(_ swiftUIView: Content) where Content: View {
        addSwiftUIView(swiftUIView, to: view)
    }

    // Present Content from UIViewController 
    func presentSwiftUIView<Content>(_ swiftUIView: Content,
                                     modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                                     animated: Bool = true,
                                     completion: (() -> Void)? = nil) where Content: View {
        let viewController = swiftUIView.asViewController
        viewController.modalPresentationStyle = modalPresentationStyle
        present(swiftUIView.asViewController, animated: animated, completion: completion)
    }
}

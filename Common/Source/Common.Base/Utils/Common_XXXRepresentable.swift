//
//  Created by Ricardo Santos on 03/03/2021.
//

import Foundation
import SwiftUI
import UIKit

//
// https://finsi-ennes.medium.com/how-to-use-live-previews-in-uikit-204f028df3a9
// https://swiftwithmajid.com/2021/03/10/mastering-swiftui-previews/
//

public extension CommonNameSpace {
    struct ViewControllerRepresentable: UIViewControllerRepresentable {
        let viewControllerBuilder: () -> UIViewController

        public init(_ viewControllerBuilder: @escaping () -> UIViewController) {
            self.viewControllerBuilder = viewControllerBuilder
        }

        public func makeUIViewController(context: Context) -> some UIViewController {
            let vc = viewControllerBuilder()
            //vc.view.backgroundColor = .cyan
            //vc.modalPresentationStyle = .overCurrentContext
            return vc
        }

        public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            // Not needed
        }
    }

    struct ViewRepresentable1: UIViewRepresentable {
        public typealias UIViewType = UIView
        let view: UIViewType
        public init(_ view: UIView) {
            self.view = view
        }
        public func makeUIView(context: Context) -> UIViewType {
            let result = view
            return result
        }
        public func updateUIView(_ uiView: UIViewType, context: Context) { }
    }

    struct ViewRepresentable2: UIViewRepresentable {
        let viewBuilder: () -> UIView
        public init(_ viewBuilder: @escaping () -> UIView) {
            self.viewBuilder = viewBuilder
        }

        public func makeUIView(context: Context) -> some UIView {
            viewBuilder()
        }

        public func updateUIView(_ uiView: UIViewType, context: Context) {
            // Not needed
        }
    }
}

struct Previews_ViewControllerRepresentable {

    class SampleVC: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            let image = ImageSFSymbol.circle.uiImage
            let imageView = UIImageView(image: image)
            view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: view.widthAnchor)
            ])
        }
    }

    #if canImport(SwiftUI) && DEBUG
    // ViewController Preview
    struct Preview1: PreviewProvider {
        static var previews: some View {
            Common_ViewControllerRepresentable { SampleVC() }
        }
    }

    // View Preview
    struct Preview2: PreviewProvider {
        static var previews: some View {
            Common_ViewRepresentable { SampleVC().view }
        }
    }
    #endif
}

//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import DevTools
import BaseUI
import AppConstants

public extension UIStackView {
    func dev_loadWithSmartReport_Resources_Images() {
        dev_addSection(title: "\(ImageName.self): \(ImageName.allCases.count) values")
        ImageName.allCases .forEach { (some) in
            common.add(uiview: some.reportView)
        }
    }
}

extension ResourcesNameSpace {

    public enum ImageName: String, CaseIterable {
        
        // Auxiliar
        case none
        
        // Not offical
        case notFound
        case noInternet

        // Official
        case car = "Car"
        case charging = "Charging"
        case close = "Close"
        
        case locked = "Locked"
        case minus = "Minus" // Use system minus "Minus"
        case plus = "Plus"
        case user = "User"
        
        case loading = "load-loading"
        case new = "i"
        
        public init?(rawValue: String) {
            if let some = Self.allCases.first(where: { $0.rawValue == rawValue }) {
                self = some
            } else {
                return nil
            }
        }
        
        public var uiImageTemplate: UIImage {
            uiImage.withRenderingMode(.alwaysTemplate)
        }
        
        public var image: Image {
            return Image(uiImage: uiImage)
        }
        
        public var imageTemplate: Image {
            return Image(uiImage: uiImageTemplate)
        }
        
        /// Prefinex fixed size for image (if exists)
        public var size: CGSize? {
            switch self {
            default: return nil
            }
        }
        
        public var uiImage: UIImage { imageWith(name: self.rawValue) }

        public func imageWith(name: String) -> UIImage {
            let bundle = Bundle(for: BundleFinder.self)
            // swiftlint:disable no_hardCodedImages
            if let result = UIImage(named: name) {
                return result
            } else if let result = UIImage(systemName: name) {
                return result
            } else if let result = UIImage(named: name, in: bundle, compatibleWith: nil) {
                return result
            } else if self == .none {
                return UIImage()
            }
            DevTools.Log.error("Image not found [\(self)]", .generic)
            // swiftlint:enable no_hardCodedImages
            return UIImage()
        }
        
    }
}

public extension ResourcesNameSpace.ImageName {
    var reportView: UIView {
        // swiftlint:disable no_UIKitAdhocConstruction
        let stackView = UIStackView.defaultHorizontalStackView()
        let caption = UILabel()
        caption.text = self.rawValue
        caption.textColor = UIStackView.fontDefaultColor()
        stackView.addArrangedSubview(caption)
        stackView.addArrangedSubview(UIView())
        let size = 30
        let imageView1 = UIImageView(image: uiImage)
        stackView.addArrangedSubview(imageView1)
        imageView1.layouts.size(CGSize(width: size, height: size))
        let imageView2 = UIImageView(image: uiImageTemplate)
        stackView.addArrangedSubview(imageView2)
        imageView2.layouts.size(CGSize(width: size, height: size))
        return stackView
        // swiftlint:enable no_UIKitAdhocConstruction
    }
}

#if canImport(SwiftUI) && DEBUG
public struct Resources_ImageName_Preview {
    private init() { }

    open class PreviewVC: BasePreviewVC {
        public override func loadView() {
            super.loadView()
            stackViewV.dev_loadWithSmartReport_Resources_Images()
        }
    }

    struct Preview: PreviewProvider {
        static var previews: some View {
            PreviewVC().asAnyView.buildPreviews()
        }
    }
}
#endif

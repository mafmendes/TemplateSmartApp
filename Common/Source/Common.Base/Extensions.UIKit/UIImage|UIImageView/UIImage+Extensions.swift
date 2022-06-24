//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable logs_rule_1

extension CommonExtension where Target == UIImage {

}

public extension UIImage {

    static func downsample(imageName: String,
                           to pointSize: CGSize,
                           scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        var result: UIImage?
        ["png", "pdf", "jpeg"].forEach { (type) in
            if let filePath = Bundle.main.url(forResource: imageName, withExtension: type),
               result != nil {
                result = downsample(imageAt: filePath, to: pointSize, scale: scale)
            }
        }
        return result

    }

    // https://medium.com/swift2go/reducing-memory-footprint-when-using-uiimage-ef0b1742cc23
    // imageURL : The image URL. It can be a web URL or a local image path
    // pointSize: The desired size of the downsampled image. Usually, this will be the UIImageView's frame size.
    // scale    : The downsampling scale factor. Usually, this will be the scale factor associated with the screen
    static func downsample(imageAt imageURL: URL,
                           to pointSize: CGSize,
                           scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            Common_Logs.error("Failed on CGImageSourceCreateWithURL")
            return nil
        }

        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale

        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            Common_Logs.error("Failed on CGImageSourceCreateThumbnailAtIndex with url [\(imageURL)]")
            return nil
        }

        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }

    func pixelColor(at pos: CGPoint = CGPoint.zero) -> UIColor {
        guard let pixelData = self.cgImage?.dataProvider?.data else {
            return .black
        }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

}

//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UIImageView {
    func toGreyScale() { target.toGreyScale() }
    func paintImageWith(color: UIColor) { target.paintImageWith(color: color) }
    func changeImageColor(to color: UIColor) { target.changeImageColor(to: color) }
}

public extension UIImageView {

    /// Sintax sugar for [func changeImageColor(to color: UIColor)]
    func paintImageWith(color: UIColor) {
        changeImageColor(to: tintColor)
    }

    /// Turn image into template image, and apply color
    func changeImageColor(to color: UIColor) {
        image = self.image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
    }

    func toGreyScale() {
        guard image != nil else { return }
        let filter  = CIFilter(name: "CIPhotoEffectMono")
        let ciInput = CIImage(image: self.image!)
        filter?.setValue(ciInput, forKey: "inputImage")
        let ciOutput   = filter?.outputImage
        let ciContext  = CIContext()
        if let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!) {
            image = UIImage(cgImage: cgImage)
        }
    }
}

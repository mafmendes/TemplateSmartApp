//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UIImageView {
    func load(url: URL, downsample: Bool = true) { target.load(url: url, downsample: downsample) }
}

public extension UIImageView {

    func load(url: URL, downsample: Bool = true) {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    // (self as UIView).rjs.stopActivityIndicator()
                    if downsample, let donwsampleImage = UIImage.downsample(imageAt: url, to: self.bounds.size) {
                        self.image = donwsampleImage
                    } else {
                        self.image = image
                    }
                }
            }
        }
    }
}

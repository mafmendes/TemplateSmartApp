//
//  Created by Ricardo Santos on 23/02/2021.
//

import Foundation
import UIKit

public extension CommonExtension where Target == CGSize {
    func addPadding(width: CGFloat, height: CGFloat) -> CGSize {
        target.addPadding(width: width, height: height)
    }
}

public extension CGSize {
    func addPadding(width: CGFloat, height: CGFloat) -> CGSize {
        CGSize(width: self.width + width, height: self.height + height)
    }
}

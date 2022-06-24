//
//  Created by Ricardo Santos on 25/02/2021.
//

import Foundation
import UIKit

public protocol CombineCompatibleProtocol { }

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
extension UIControl: CombineCompatibleProtocol { }

public extension UIControl {
    var combine: CombineCompatible { return CombineCompatible(target: self) }
}

public struct CombineCompatible {
    public let target: UIControl
}

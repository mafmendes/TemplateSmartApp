//
//  Created by Santos, Ricardo Patricio dos  on 15/04/2021.
//

import Foundation
import Combine
import UIKit

public extension UIView {
    class func animatePublisher(withDuration duration: TimeInterval,
                                animations: @escaping () -> Void) -> Future<Bool, Never> {
        Future { promise in
            UIView.animate(withDuration: duration, animations: animations) {
                promise(.success($0))
            }
        }
    }
}

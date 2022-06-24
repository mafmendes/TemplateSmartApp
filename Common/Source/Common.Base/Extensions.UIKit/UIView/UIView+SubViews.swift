//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

///////////// UTILS DEV /////////////

public extension CommonExtension where Target == UIView {
    var allSubviews: [UIView] { target.allSubviews }
    func allSubviewsWith(tag: Int, recursive: Bool) -> [UIView] { target.allSubviewsWith(tag: tag, recursive: recursive) }
    func allSubviewsWith(type: AnyClass) -> [UIView] { target.allSubviewsWith(type: type) }

    func removeAllSubviewsRecursive() { target.removeAllSubviewsRecursive() }
    func allSubviewsRecursive<T: UIView>() -> [T] {  target.allSubviewsRecursive() }
}

public extension UIView {

    var allSubviews: [UIView] { allSubviewsRecursive() }
    func removeAllSubviewsRecursive() {
        let allViews = UIView.allSubviewsRecursive(from: self) as [UIView]
        _ = allViews.map { (some) -> Void in
            if let viewController = some.common.viewController {
                viewController.destroy()
            }
            some.removeFromSuperview()
        }
    }

    func allSubviewsWith(type: AnyClass) -> [UIView] {
        allSubviews.filter({ $0.isKind(of: type) })
    }

    func allSubviewsWith(tag: Int, recursive: Bool) -> [UIView] {
        if recursive {
            return UIView.allSubviewsRecursive(from: self).filter { $0.tag == tag }
        } else {
            return subviews.filter { $0.tag == tag }
        }
    }

    class func allSubviewsRecursive<T: UIView>(from view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = allSubviewsRecursive(from: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }

    func allSubviewsRecursive<T: UIView>() -> [T] { UIView.allSubviewsRecursive(from: self) as [T] }

}

//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public extension NSObject {
    var className: String { return String(describing: type(of: self)) }
    static var className: String { return String(describing: self) }
}

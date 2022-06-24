//
//  Created by Ricardo Santos on 17/01/2021.
//

import Foundation
import UIKit

public extension AppConstantsNameSpace {    
    struct Misc {
        private init() { }
        public static var defaultDelayMocks: Double { Double.random(in: 0.5...2) } // seconds
        public static var defaultDisabledAlpha: Double { 0.6 }
    }
}

//
//  Created by Ricardo Santos on 17/01/2021.
//

import Foundation
import UIKit

public extension AppConstantsNameSpace {    
    struct TimeIntervals {
        private init() { }
        public static var defaultDelayMocks: Double { Double.random(in: 0.5...2) } // seconds
        public static let defaultAnimationDuration: Double = 0.33      // seconds
        public static let defaultDebounceValueForLoading: Double = 0.1 // seconds
        public static let defaultDebounceForLoading: RunLoop.SchedulerTimeType.Stride = .seconds(defaultDebounceValueForLoading)
        public static let defaultDebounceForTap: RunLoop.SchedulerTimeType.Stride = .milliseconds(750) // tap buttons
    }
}

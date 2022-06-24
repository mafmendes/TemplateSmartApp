//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit

// swiftlint:disable logs_rule_1

extension CommonNameSpace {
    public struct Cronometer {

        /**
         * RJSCronometer.printTimeElapsedWhenRunningCode("nthPrimeNumber")
         * {
         *    log(RJSCronometer.nthPrimeNumber(10000))
         * }
         */
        @discardableResult
        public static func printTimeElapsedWhenRunningCode(_ title: String, operation: () -> Void) -> Double {
            let startTime = CFAbsoluteTimeGetCurrent()
            operation()
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            Logger.info("Time elapsed for \(title): \(timeElapsed)s")
            return timeElapsed
        }

        public static func timeElapsedInSecondsWhenRunningCode(_ operation:() -> Void) -> Double {
            let startTime = CFAbsoluteTimeGetCurrent()
            operation()
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            return Double(timeElapsed)
        }

        private static var _times: [String: CFAbsoluteTime] = [:]

        public static func startTimerWith(identifier: String="") {
            synced(_times) {
                _times.removeValue(forKey: identifier)
                _times[identifier] = CFAbsoluteTimeGetCurrent()
            }
        }

        public static func timeElapsed(identifier: String="", print: Bool) -> Double? {
            var result: Double?
            synced(_times) {
                if let time = _times[identifier] {
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - time
                    if print {
                        Common_Logs.info("Operation [\(identifier)] time : \(Double(timeElapsed))" as AnyObject)
                    }
                    result = Double(timeElapsed)
                }
            }
            return result ?? 0
        }

        public static func remove(identifier: String) {
            _ = synced(_times) {
                _times.removeValue(forKey: identifier)
            }
        }
    }
}

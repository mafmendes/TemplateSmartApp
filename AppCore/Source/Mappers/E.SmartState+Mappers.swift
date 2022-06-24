//
//  Created by Ricardo Santos on 23/01/2021.
//

import Foundation
//
import Common
import WebAPIDomain
import BaseDomain
import DevTools
import AppDomain

public extension SmartState {

    /// Sugar helpers for : Given car properties, return stats
    enum Mappers {
        /// Sugar. Returns the state for a button (associated to trunk lock) depend on the trunk state
        public static func stateForTrunk(trunckIsLocked: Bool) -> SmartState {
            trunckIsLocked ? .default : .selectedDisabled
        }
        
        /// Sugar. Returns the state for a button (associated to central lock) depend on the central lock state
        public static func stateForCentralLock(isLocked: Bool) -> SmartState {
            // If locked, show default state
            isLocked ? .default : .selected
        }
        
        /// Sugar. Returns the state for a button (associated to windows vent) depend on the windows vent state
        public static func stateForWindowsAreVented(state: Bool) -> SmartState {
            state ? .selected : .default
        }
    }
}

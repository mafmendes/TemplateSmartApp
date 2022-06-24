//
//  Created by Ricardo Santos on 15/03/2021.
//

import SwiftUI
import Combine

// swiftlint:disable logs_rule_1

public extension CommonNameSpace {
    
    // Objects marked as @ObservedObject need to implement ObservableObject protocol and have
    // properties defined with the @Published property wrapper, indicating which properties
    // trigger observation notifications when changed.
    final class GenericStore<Value, Action>: ObservableObject {

        // Reducer that takes a value and action and return a new value
        let reducer: (inout Value, Action) -> Void
        @Published public var value: Value
        public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
            self.value = initialValue
            self.reducer = reducer
        }

        public func send(_ action: Action, debug: Bool = false) {
            if debug {
                Common_Logs.debug("Sent action [\(action)]")
            }
            self.reducer(&self.value, action)
        }
    }
}

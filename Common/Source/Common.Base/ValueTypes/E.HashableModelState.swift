//
//  Created by Ricardo Santos on 18/02/2021.
//

import Foundation
import Combine
import SwiftUI

// swiftlint:disable logs_rule_1

//
// https://medium.com/eggs-design/building-a-state-driven-app-in-swiftui-using-state-machines-32379ca37283
// Building a state-driven app in SwiftUI using state machines
//

public extension CommonNameSpace {

    enum HashableModelState<T: Hashable>: Hashable {
        public static func == (lhs: CommonNameSpace.HashableModelState<T>, rhs: CommonNameSpace.HashableModelState<T>) -> Bool {
            switch (lhs, rhs) {
            case (.notLoaded, .notLoaded):
                return true
            case (.loading, .loading):
                return true
            case (.loaded(let t1), .loaded(let t2)):
                return t1 == t2
            case (.error, .error):
                return true
            default:
                return false
            }
        }

        case notLoaded
        case loading
        case loaded(T)
        case error(Error)

        public var selfValue: Int {
            switch self {
            case .notLoaded: return 1
            case .loading: return 2
            case .loaded: return 3
            case .error: return 4
            }
        }

        public var value: T? {
            switch self {
            case .loaded(let t): return t
            default: return nil
            }
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(selfValue)
            switch self {
            case .loaded(let t):
                hasher.combine(t)
            default: ()
            }
        }
    }
}

fileprivate extension CommonNameSpace {

    func sample() {
        struct SomethingHashable: Hashable {
            public var currencyCode: String
            public func hash(into hasher: inout Hasher) {
                hasher.combine(currencyCode)
            }
        }

        var state: CommonNameSpace.HashableModelState<SomethingHashable?> = .notLoaded
        Common_Logs.info(state)

        state = CommonNameSpace.HashableModelState.loaded(SomethingHashable(currencyCode: "EUR"))
        Common_Logs.info(state)

    }
}

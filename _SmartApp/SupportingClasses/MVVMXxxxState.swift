//
//  Created by Ricardo Santos on 20/03/2021.
//

import Foundation
import Combine
import UIKit
//
import Resources
import Common
import BaseDomain
import BaseUI
import AppDomain

// Objects marked as @ObservedObject need to implement ObservableObject protocol and have
// properties defined with the @Published property wrapper, indicating which properties
// trigger observation notifications when changed.
public class MVVMViewInputObservable<T: Hashable>: ObservableObject {
    public init() { }
    public var value = PassthroughSubject<MVVMViewInput<T>, Never>()
}

public enum MVVMViewInput<T: Hashable>: Hashable {
    public static func == (lhs: MVVMViewInput<T>, rhs: MVVMViewInput<T>) -> Bool {
        switch (lhs, rhs) {
        case (.softReLoad, .softReLoad): return true
        case (.loading, .loading): return true
        case (.loaded(let t1), .loaded(let t2)):  return t1 == t2
        case (.error, .error): return true
        default:  return false
        }
    }

    case loading(_ model: BaseDisplayLogicModels.Loading)
    case loaded(T)
    case softReLoad // Use to put the screen/view on his initial state, (not necessaring reload all the data)
    case error(Error, devMessage: String)

    public var selfValue: Int {
        switch self {
        case .softReLoad: return 1
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
        case .loaded(let t): hasher.combine(t)
        default: ()
        }
    }
}

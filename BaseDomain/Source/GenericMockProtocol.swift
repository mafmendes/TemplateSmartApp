//
//  Created by Ricardo Santos on 18/03/2021.
//

import Foundation

// All the mock classes are mandatory to implement this
public protocol GenericMockProtocol {
    associatedtype InitialStateType: Hashable

    var initialState: InitialStateType { get set }
    init(initialState: InitialStateType)
}

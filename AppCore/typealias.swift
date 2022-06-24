//
//  Created by Ricardo Santos on 05/02/2021.
//

import Foundation

/**
 __ABOUT:__
 
 */

public struct AppCoreNameSpace {
    private init() { }
    public struct UseCase {
        private init() { }
    }
}

public struct AssembyContainer { private init() {} }
public typealias AS = AssembyContainer

public typealias AppCoreProtocols      = AppCoreNameSpace.AppCoreProtocolsNamed
public typealias CoreProtocolsResolved = AppCoreNameSpace.CoreProtocolsResolved

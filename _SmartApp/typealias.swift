//
//  Created by Ricardo Santos on 19/03/2021.
//

import Foundation

public struct SmartAppNameSpace {
    private init() { }
}

// Encapsulate the ViewControllers Assemblys
public struct AssemblersResolversNameSpace { private init() {} }
public typealias DI = AssemblersResolversNameSpace

public typealias UIFactory = SmartAppNameSpace.UIFactory

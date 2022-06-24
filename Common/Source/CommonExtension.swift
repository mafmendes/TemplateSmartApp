//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

public struct CommonExtension<Target> {
    public let target: Target
    init(_ target: Target) { self.target = target }
}

public protocol CommonExtensionCompatible { }

public extension CommonExtensionCompatible {
    var common: CommonExtension<Self> { return CommonExtension(self) }                   /* instance extension */
    static var common: CommonExtension<Self>.Type { return CommonExtension<Self>.self }  /* static extension */
}

extension NSObject: CommonExtensionCompatible { }

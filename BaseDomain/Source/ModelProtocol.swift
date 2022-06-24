//
//  Created by Ricardo Santos on 07/02/2021.
//

import Foundation

// To encapsulate all Model's (used on views)
public struct Model {
    private init() { }
}

public protocol ModelProtocol: Codable, Hashable, CustomStringConvertible {

}

// By inheriting the CustomStringConvertible protocol, we need to provide a value to the description property.
// Every time, we want to use the object as a String, the program will refer to the description property.
// Now we can manage our message in one place :)

/**
 __Fast compliance__
```
init?(rawValue: String?) { fatalError() }
public init(from decoder: Decoder) throws { fatalError() }
public func encode(to encoder: Encoder) throws { fatalError() }
static public func ==(lhs: AccountTiles, rhs: AccountTiles) -> Bool { fatalError() }
public func hash(into hasher: inout Hasher) { fatalError() }
```
*/

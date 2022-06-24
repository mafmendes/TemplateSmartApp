//
//  Created by Ricardo Santos on 08/02/2021.
//

import Foundation

// To encapsulate all Data Transation Objects (Request and responses)
public struct ModelDto {
    private init() { }
}

// By inheriting the CustomStringConvertible protocol, we need to provide a value to the description property.
// Every time, we want to use the object as a String, the program will refer to the description property.
// Now we can manage our message in one place :)

public protocol ModelDtoProtocol: Codable, Hashable, CustomStringConvertible {

}

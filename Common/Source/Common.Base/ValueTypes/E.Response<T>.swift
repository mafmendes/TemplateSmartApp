//
//  Created by Ricardo Santos on 22/02/2021.
//

import Foundation

public extension CommonNameSpace {
    struct Response<T: Decodable> {
        public let value: T
        public let response: Any
        public init(value: T, response: Any) {
            self.value = value
            self.response = response
        }
    }
}

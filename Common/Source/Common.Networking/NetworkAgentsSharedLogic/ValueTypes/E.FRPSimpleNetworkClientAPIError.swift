//
//  Created by Ricardo Santos on 21/01/2021.
//

import Foundation

public extension NetworkinNameSpace {
    enum FRPSimpleNetworkClientAPIError: Error {
       case ok // no error
       case cacheNotFound // no error
       case genericError
       case parsing(description: String)
       case network(description: String)
       case failedWithStatusCode(code: Int)
       case decodeFail(description: String)
    }
}

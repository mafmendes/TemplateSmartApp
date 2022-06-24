//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
//
import RJSLibUFNetworking

public enum AppErrors: Error {
   case ok // No error
   case genericError
   case cacheNotFound // No error
   case parsing(description: String)
   case network(description: String)
   case failedWithStatusCode(code: Int)
}

public extension FRPSimpleNetworkClientAPIError {
    var toAppError: AppErrors {
        switch self {
        case .ok: return .ok
        case .cacheNotFound: return .cacheNotFound
        case .genericError: return .genericError
        case .parsing(description: let description): return .parsing(description: description)
        case .network(description: let description): return .network(description: description)
        case .failedWithStatusCode(code: let code): return .failedWithStatusCode(code: code)
        case .decodeFail: return .genericError
        }
    }
}

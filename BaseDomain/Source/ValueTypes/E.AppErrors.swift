//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
//
import Common
import DevTools
import AppConstants

public extension BaseDomainNameSpace {
    enum AppErrors: Error, Equatable, Hashable {
        case ok // No error
        case cacheNotFound // No error

        case genericError(devMessage: String)
        case recordNotFound
        case parsing(description: String)    // For parse errors
        case network(description: String)    // For network error errors
        case failedWithStatusCode(code: Int) // For generic status code errors
        
        case noInternetConnection

    }
}

public extension Common_FRPNetworkAgentAPIError {
    var toAppError: AppErrors {
        switch self {
        case .ok:                                    return .ok
        case .cacheNotFound:                         return .cacheNotFound
        case .genericError:                          return .genericError(devMessage: "")
        case .parsing(description: let description): return .parsing(description: description)
        case .network(description: let description): return .network(description: description)
        case .failedWithStatusCode(code: let code):  return .failedWithStatusCode(code: code)
        case .decodeFail:                            return .genericError(devMessage: "decodeFail")
        }
    }
}

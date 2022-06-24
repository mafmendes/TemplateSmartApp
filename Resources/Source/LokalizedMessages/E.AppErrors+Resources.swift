//
//  Created by Santos, Ricardo Patricio dos  on 13/07/2021.
//

import Foundation
import UIKit
//
import DevTools
import AppConstants
import BaseDomain

extension AppErrors {
    
    /// Returns a "friendly / not tecnical" localization for the users
    public var localisedForUser: String? {
        localised
    }
    
    /// Return a localization for the Dev Team
    public var localisedForDevTeam: String? {
        "\(self)"
    }
    
    /// Returns a "friendly / not tecnical" localization for the users
    public var localised: String? {
        switch self {
        case .ok: return nil
        case .cacheNotFound: return Message.pleaseTryAgainLater.localised
        case .genericError: return Message.pleaseTryAgainLater.localised
        case .recordNotFound: return Message.pleaseTryAgainLater.localised
        case .parsing: return Message.pleaseTryAgainLater.localised
        case .network: return Message.pleaseTryAgainLater.localised
        case .failedWithStatusCode: return Message.pleaseTryAgainLater.localised
        case .noInternetConnection: return Message.noInternet.localised
        }
    }
}

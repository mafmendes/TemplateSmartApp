//
//  Created by Ricardo Santos on 21/01/2021.
//

import Foundation
import UIKit
//
import DevTools
import AppConstants
import BaseDomain

//
// MARK: - Message
//

extension ResourcesNameSpace {
    // Shortcut for common app messages
    public enum Message: Int, CaseIterable {
        case alert = 0           // AAA
        case back                // BBB
        case cancel
        case delete              // DDD
        case details
        case dismiss
        case `description`
        case invalidEmail        // III
        case invalidCredentials
        case login               // LLL
        case loading1
        case loading2
        case no                  // NNN
        case noRecords
        case noInternet
        case ok                  // OOO
        case pleaseTryAgainLater // PPP
        case pleaseWait
        case password
        case search              // SSS
        case select
        case success
        case save
        case userName            // UUU
        case yes                 // YYY
        public static var defaultErrorMessage: String {
            return Message.pleaseTryAgainLater.localised
        }

        public var localised: String {
            return AppResources.localizedWith("generic.\(self)")
        }

        public static func messageWith(error: Error) -> String {
            return pleaseTryAgainLater.localised
        }
    }
}

//
// MARK: - AppResources
//

public struct AppResources {
    private init() {}

    static func localizedWith(_ key: String) -> String {
        guard !key.trim.isEmpty else {
            DevTools.assertFailure("Invalid localizable: \(key)", forceFix: true)
            return key
        }
        let bundle = Bundle(identifier: ResourcesNameSpace.bundleIdentifier)!
        let localized = NSLocalizedString(key, bundle: bundle, comment: "")
        if localized.trim.isEmpty {
            DevTools.assertFailure("Invalid localizable: \(key)", forceFix: true)
            return key
        }
        if localized == key {
            DevTools.assertFailure("Invalid localizable: \(key)", forceFix: DevTools.onDevMode)
            return key
        }
        return localized
    }
}

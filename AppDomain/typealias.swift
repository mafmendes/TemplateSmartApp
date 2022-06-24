//  Domain
//
//  Created by Ricardo Santos on 05/02/2021.
//

import Foundation
import Combine
import UIKit
//
import Common
import BaseDomain
import DevTools

/**
 __ABOUT:__
 
 */

public struct AppDomainNameSpace {
    private init() { }
    public enum UserInterfaceValueTypes { }
}

public typealias UserInterfaceValueTypes = AppDomainNameSpace.UserInterfaceValueTypes
public typealias AccessibilityIdentifier = UserInterfaceValueTypes.AccessibilityIdentifier
public typealias SmartState = UserInterfaceValueTypes.SmartState

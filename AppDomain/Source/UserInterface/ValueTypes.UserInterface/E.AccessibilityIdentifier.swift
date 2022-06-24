//
//  Created by Santos, Ricardo Patricio dos  on 31/03/2021.
//

import Foundation
import SwiftUI

/**
 
 # About ValueTypes inside _ValueTypes.UserInterface_ folder

 * _ValueTypes_ used by _UseCases_ to return information requested by the _UserInterface_
 * This ValueTypes are generaly requested by _ViewModels_ to be fwd and latter used by the _Views_
 */

// swiftlint:disable identifier_name

#warning("Tutorial : Accessibility codes. change acording to project")

public extension UserInterfaceValueTypes {
    
    enum AccessibilityIdentifier: String, CaseIterable {
        
        case na = "na" // Not Applyed
        case dev_panModalView                 // The PanView

        //
        // Toolbar
        //
        case toolBarBtn1WithMeaningfulName
        case toolBarBtn2WithMeaningfulName
        case toolBarBtn3WithMeaningfulName
        case toolBarBtn4WithMeaningfulName
        
        //
        // App Tab 1 : Account
        //
                        
        case accountUserNameLbl = "navbar.userCar.text"

        case someLabel = "template.some.label"

        public var value: String { rawValue }
        
        // Generic buttons
        case btnPlus = "btnPlus"

        var localized: String {
            ""
        }
    }
}

public extension View {
    func accessibility(_ accessibilityIdentifier: AccessibilityIdentifier) -> some View {
        accessibility(identifier: accessibilityIdentifier.value)
    }
}

//
//  Created by Santos, Ricardo Patricio dos  on 16/04/2021.
//

import Foundation

/**
 
 # About ValueTypes inside _ValueTypes.UserInterface_ folder

 * _ValueTypes_ used by _UseCases_ to return information requested by the _UserInterface_
 * This ValueTypes are generaly requested by _ViewModels_ to be fwd and latter used by the _Views_
 */

public extension SmartState {

    var isUserInteractionEnabled: Bool {
        switch self {
        
        case .default: return true
        case .selected: return true

        case .defaultHighlighted: return true
        case .defaultDisabled: return false
    
        case .selectedHighlighted: return true
        case .selectedDisabled: return false
    
        case .loading: return false
        case .loadingSelected: return false
        case .loadingDefault: return false
        }
    }
    
    var flipedValue: Self {
        switch self {
        
        case .default: return .selected
        case .selected: return .default

        case .defaultHighlighted: return .selected
        case .defaultDisabled: return .selected
            
        case .selectedHighlighted: return .default
        case .selectedDisabled: return .default
        
        case .loading: return .default
        case .loadingSelected: return .default
        case .loadingDefault: return .selected
        }
    }
    
    var isAnyLoading: Bool {
        self == .loading || self == .loadingSelected || self == .loadingDefault
    }
    
}

public extension UserInterfaceValueTypes {

    enum SmartState: Int, CaseIterable {
        
        case `default` = 1
        case defaultHighlighted
        case defaultDisabled

        case selected
        case selectedHighlighted
        case selectedDisabled

        case loading
        case loadingSelected
        case loadingDefault

        public init?(rawValue: Int) {
            if let some = Self.allCases.first(where: { $0.rawValue == rawValue }) {
                self = some
            } else {
                return nil
            }
        }
    }
    
}

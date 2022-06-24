//
//  Created by Santos, Ricardo Patricio dos  on 13/05/2021.
//

import Foundation
import UIKit
//
import DevTools
import AppConstants
import AppDomain

//
// MARK: - SmartState
//

public extension SmartState {
    
    var imageName: ImageName {
        switch self {
        case .default: return .notFound
        case .defaultHighlighted: return .notFound
        case .defaultDisabled: return .notFound
        case .selected: return .notFound
        case .selectedHighlighted: return .notFound
        case .selectedDisabled: return .notFound
        case .loading: return .notFound
        case .loadingSelected :return .notFound
        case .loadingDefault: return .notFound
        }
    }
    
}

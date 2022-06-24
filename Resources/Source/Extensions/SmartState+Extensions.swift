//
//  Created by Santos, Ricardo Patricio dos  on 01/12/2021.
//

import Foundation
//
import AppDomain

public extension SmartState {
    var localized: String {
        switch self {
        case .default: return "default".localized
        case .defaultHighlighted: return "default".localized
        case .defaultDisabled: return "defaultDisabled".localized
        case .selected: return "selected".localized
        case .selectedHighlighted: return "selectedHighlighted".localized
        case .selectedDisabled: return "selectedDisabled".localized
        case .loading: return "loading".localized
        case .loadingSelected: return "loadingSelected".localized
        case .loadingDefault: return "loadingDefault".localized
        }
    }
}

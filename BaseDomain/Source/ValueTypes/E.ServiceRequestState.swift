//
//  Created by Santos, Ricardo Patricio dos  on 03/05/2021.
//

import Foundation
import UIKit

public extension BaseDomainNameSpace {
    enum ServiceRequestState {
        case unknow
        case valid      // Data is valid
        case refreshing // Data is refreshing
    }
}

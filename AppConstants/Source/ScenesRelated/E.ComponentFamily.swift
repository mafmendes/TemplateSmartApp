//
//  Created by Santos, Ricardo Patricio dos  on 31/03/2021.
//

import Foundation

public extension AppConstantsNameSpace {

    enum AppsTags: Int {
        case na = 1

        // base
        case view
        case loadingView
        case viewContainer
        case button
        case label
        case imageView
        case scrollView
        case table
        case stackView
        case textField
        
        public var tag: Int { rawValue }
    }
}

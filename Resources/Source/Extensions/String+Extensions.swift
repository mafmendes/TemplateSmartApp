//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//

import Foundation
import DevTools

public extension String {
    var localized: String { AppResources.localizedWith(self) }
    
    var localizedMissing: String {
        DevTools.Log.warning("Missing localized", .generic)
        return self
    }

}

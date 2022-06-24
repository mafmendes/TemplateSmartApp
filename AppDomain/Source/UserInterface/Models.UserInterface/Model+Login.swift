//
//  Created by Santos, Ricardo Patricio dos  on 27/04/2021.
//

import Foundation
//
import BaseDomain
import DevTools
import Common

public extension Model {

    struct Login: ModelProtocol {
        public var sucess: Bool
        
        public init() {
            sucess = false
        }

        enum CodingKeys: String, CodingKey {
            case sucess
        }
        
        public static var random: Self {
            var some = Login()
            some.sucess = Bool.random()
            return some
        }
    }
}

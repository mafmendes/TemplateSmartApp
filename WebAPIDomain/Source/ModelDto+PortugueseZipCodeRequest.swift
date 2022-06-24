//
//  Created by Santos, Ricardo Patricio dos  on 05/12/2021.
//

import Foundation
//
import BaseDomain

public extension ModelDto {
    struct PortugueseZipCodeRequest: ModelDtoProtocol {

        public let path: String
        
        public init(path: String) {
            self.path = path
        }
    }
}

//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation

public extension BaseDomainNameSpace {
    enum CachePolicy {
        case ignoringCache
        case cacheElseLoad
        case cacheAndLoad
        case cacheDontLoad
    }
}

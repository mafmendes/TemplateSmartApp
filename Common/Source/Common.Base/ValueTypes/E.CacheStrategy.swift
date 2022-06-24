//
//  Created by Ricardo Santos on 22/02/2021.
//

import Foundation

public extension CommonNameSpace {
    enum CacheStrategy: Hashable {
        case cacheNoLoad   // Use cache only
        case noCacheLoad   // Cache ignored, and returns latest available value
        case cacheElseLoad // Will use cache if available, else returns latest available value (good because avoids server calls)
        case cacheAndLoad  // Can emit twice, one for cache (if available) and other with the latest available value
        public var canUseCache: Bool {
            return self != .noCacheLoad
        }
    }
}

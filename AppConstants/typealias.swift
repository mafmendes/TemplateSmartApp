//
//  Created by Ricardo Santos on 21/01/2021.
//

/**
 __ABOUT:__

 App constants
 
 */

import Foundation

public struct AppConstantsNameSpace {
    private init() { }
    
    static let defaultAnimationDuration = TimeIntervals.defaultAnimationDuration
}

public typealias AppConstants  = AppConstantsNameSpace
public typealias SizeNames     = AppConstantsNameSpace.SizesNames
public typealias AppTags       = AppConstantsNameSpace.AppsTags
public typealias TimeIntervals = AppConstantsNameSpace.TimeIntervals

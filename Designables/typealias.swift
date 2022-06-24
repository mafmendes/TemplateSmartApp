//
//  Created by Ricardo Santos on 11/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import AppConstants

/**
 __ABOUT:__
 
 Here we have atomic components that could in theory be used in every app. If the component have some kind of app logic, should be
 put on __SmartApp/Scenes/Support.Views__
 */

public struct DesignablesNameSpace {
    private init() {}
    public enum UIKit { }
    public enum SwiftUI { }
}

public typealias App_Designables           = DesignablesNameSpace
public typealias App_Designables_UIKit     = DesignablesNameSpace.UIKit
public typealias App_Designables_SwiftUI   = DesignablesNameSpace.SwiftUI

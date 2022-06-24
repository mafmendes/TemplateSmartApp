//
//  Created by Ricardo Santos on 19/03/2021.
//

import Foundation
import UIKit
import SwiftUI

/**
 __ABOUT:__
 
 */

public struct ResourcesNameSpace {
    private init() { }
    static var bundleIdentifier: String { Bundle(for: BundleFinder.self).bundleIdentifier ?? "" }
}

internal class BundleFinder { }

public typealias Lokalizable   = ResourcesNameSpace.Message
public typealias Message       = ResourcesNameSpace.Message
public typealias ImageName     = ResourcesNameSpace.ImageName

public typealias FontSemanticSmart         = UIFont.PackSmart.FontSemanticSmart
public typealias AppFontsSmartStyleOptions = ResourcesNameSpace.AppFontsSmartStyleOptions

public typealias ColorSemantic = UIColor.ColorSemantic
internal typealias ColorPallete = UIColor.ColorPallete // Internal acess only

public typealias ColorPackApple = UIColor.AppleDefault
public typealias ButtontStyle = UIButton.SmartLayoutStyle

//####################### Utils Types #######################//
//####################### Utils Types #######################//
//####################### Utils Types #######################//

public typealias TextStyleTuple = (font: FontSemanticSmart, color: ColorSemantic?, options: [AppFontsSmartStyleOptions]?)

/// Sugar to help controls that change color on tap. selected == Highlighted == taped
public typealias BackgroundStyleTuple = (notSelected: AnyView, selected: AnyView)

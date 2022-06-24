//
//  Created by Santos, Ricardo Patricio dos  on 11/04/2021.
//

import Foundation
import UIKit
//
import Common

public extension ResourcesNameSpace {
    static func setup() {
        let bundleIdentifier = Bundle(for: BundleFinder.self).bundleIdentifier!
        UIFont.registerFontWithFilenameString("FORsmartNext-Bold.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("FORsmartNext-Regular.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("SF-Pro-Display-Regular.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("SF-Pro-Text-Regular.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("SF-Pro-Display-Semibold.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("SF-Pro-Text-RegularItalic.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("SF-Pro-Text-Semibold.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("SF-Pro-Text-SemiboldItalic.otf", bundleIdentifier)
        UIFont.registerFontWithFilenameString("SF-Compact-Display-Thin.otf", bundleIdentifier)
    }
}

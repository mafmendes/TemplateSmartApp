//
//  Created by Santos, Ricardo Patricio dos  on 11/04/2021.
//

import Foundation
import UIKit

public extension UIFont {
    
    static func registerFontWithFilenameString(_ filenameString: String, _ bundleIdentifier: String) {
        if let frameworkBundle = Bundle(identifier: bundleIdentifier) {
            guard let pathForResourceString = frameworkBundle.path(forResource: filenameString, ofType: nil) else {
                return
            }
            let fontData = NSData(contentsOfFile: pathForResourceString)
            let dataProvider = CGDataProvider(data: fontData!)
            let fontRef = CGFont(dataProvider!)
            var errorRef: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) {
                assert(false, "Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
        } else {
            assert(false, "Failed to register font - bundle identifier invalid.")
        }
    }
}

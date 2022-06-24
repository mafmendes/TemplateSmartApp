//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import Common

public extension TextField {
    
    @inlinable func applyStyle(_ style: TextStyleTuple, _ theme: Common_ColorScheme? = nil) -> some View {
        applyStyle(style.font, style.color, theme)
    }
    
    @inlinable func applyStyle(_ style: FontSemanticSmart,
                               _ colorSemantic: ColorSemantic?,
                               _ theme: Common_ColorScheme? = nil) -> some View {
        let textColorForTheme = UIColor.colorWith(colorSemantic, nil, theme)
        return font(style.font)
            .ifCondition(textColorForTheme != nil) {
                $0.textColor(Color(textColorForTheme!))
            }
    }
}

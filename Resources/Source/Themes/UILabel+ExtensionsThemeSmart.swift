//
//  Created by Santos, Ricardo Patricio dos  on 02/04/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import Common

public extension ResourcesNameSpace {
    enum AppFontsSmartStyleOptions {
        case fade_06
        case alignLeft
        case alignRight
    }
}

public extension Text {
    
    @inlinable func applyStyle(_ style: TextStyleTuple, _ theme: Common_ColorScheme? = nil) -> some View {
        applyStyle(style.font, style.color, style.options, theme)
    }
    
    @inlinable func applyStyle(_ style: FontSemanticSmart,
                               _ colorSemantic: ColorSemantic?,
                               _ options: [AppFontsSmartStyleOptions]? = nil,
                               _ theme: Common_ColorScheme? = nil) -> some View {
        let textColorForTheme = UIColor.colorWith(colorSemantic, options, theme)
        let alignLeft: Bool = ((options?.first(where: { $0 == .alignLeft })) != nil)
        let alignRight: Bool = ((options?.first(where: { $0 == .alignRight })) != nil)
        return font(style.font)
            .ifCondition(textColorForTheme != nil) {
                $0.textColor(Color(textColorForTheme!))
            }.ifCondition(alignLeft) {
                $0.frame(alignment: .leading)
            }.ifCondition(alignRight) {
                $0.frame(alignment: .trailing)
            }
    }
}

public extension UILabel {
    
    var layoutStyle: FontSemanticSmart {
        get { return .notApplied }
        set { applyStyle(newValue, nil) }
    }
    
    func applyStyle(_ style: TextStyleTuple, _ theme: Common_ColorScheme? = nil) {
        applyStyle(style.font, style.color, style.options, theme)
    }
    
    func applyStyle(_ style: FontSemanticSmart,
                    _ colorSemantic: ColorSemantic?,
                    _ options: [AppFontsSmartStyleOptions]? = nil,
                    _ theme: Common_ColorScheme? = nil) {

        var theme: Common_ColorScheme? = theme
        if theme == nil {
            theme = traitCollection.userInterfaceStyle == .dark ? .dark : .light
        }
        font = style.uiFont
        if let textColorForTheme = UIColor.colorWith(colorSemantic, options, theme) {
            textColor = textColorForTheme
        }
        
        options?.forEach({ some in
            switch some {
            case .fade_06: alpha = 0.6
            case .alignLeft: textAlignment = .left
            case .alignRight: textAlignment = .right
            }
        })
        
        /// Given a label with a style X, and with a subString, will apply a diferent style on the subString only
        func applyStyle(_ subStyle: FontSemanticSmart, onSubString subString: String) {
            guard !subString.trim.isEmpty else { return }
            // swiftlint:disable no_UIKitAdhocConstruction
            let subLabel = UILabel()
            // swiftlint:enable no_UIKitAdhocConstruction
            subLabel.layoutStyle = subStyle
            
            let baseStyleAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
            let subStyleAttributes  = [NSAttributedString.Key.font: subLabel.font, NSAttributedString.Key.foregroundColor: subLabel.textColor]
            
            // Get original text
            var originalText = ""
            if text != nil {
                originalText = text!
            }
            if attributedText?.string != nil {
                originalText = attributedText!.string
            }
            
            // Prepare sub-string. Should is be upperced or lowercased?
            var subStringEscaped = subString
            
            if originalText.uppercased() == originalText {
                // base text is uppercased!
                subStringEscaped = subStringEscaped.uppercased()
            }
            
            if originalText.lowercased() == originalText {
                // base text is lowercased!
                subStringEscaped = subStringEscaped.lowercased()
            }
            
            guard !originalText.trim.isEmpty else { return }
            
            let mainStyleAttributedString = NSMutableAttributedString(string: originalText, attributes: baseStyleAttributes as [NSAttributedString.Key: Any])
            let subStyleAttributedString  = NSMutableAttributedString(string: subStringEscaped, attributes: subStyleAttributes as [NSAttributedString.Key: Any])
            
            // Get range of text to replace
            guard let range = mainStyleAttributedString.string.range(of: subStringEscaped) else {
                // Not found
                return
            }
            let nsRange = NSRange(range, in: mainStyleAttributedString.string)
            mainStyleAttributedString.replaceCharacters(in: nsRange, with: subStyleAttributedString)
            
            text = nil
            attributedText = mainStyleAttributedString
        }
        
    }
    
}

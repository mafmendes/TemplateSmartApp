//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
//
import DevTools
import Common
import BaseUI

public extension UIStackView {
    func dev_loadWithSmartReport_Resources_Fonts() {
        dev_addSection(title: "\(FontSemanticSmart.self): \(FontSemanticSmart.allCases.count) values")
        FontSemanticSmart.allCases .forEach { (some) in
            common.add(uiview: some.reportView)
        }
    }
}

public extension UIFont {
    
    struct PackSmart {
        
        enum Fonts: String {
            case sfCompactDisplayThin    = "SF Compact Display Thin"
            case sfProDisplayRegular     = "SF Pro Display Regular"
            case sfProDisplaySemibold    = "SF Pro Display Semibold"
            case sfProTextRegular        = "SF Pro Text Regular"
            case sfProTextRegularItalic  = "SF Pro Text Regular Italic"
            case sfProTextSemibold       = "SF Pro Text Semibold"
            case sfProTextSemiboldItalic = "SF Pro Text Semibold Italic"
            
            var name: String {
                rawValue
            }
        }

        // Find better name
        public enum FontSemanticSmart: CaseIterable {
            
            case notApplied

            case largeTitleThin
            case largeTitle
            
            case title1
            case title2
            
            case headline
            case body
            case bodyBold
            case footnote, footnoteBold
            case caption1, caption1Bold
            case caption2, caption2Bold

            public var uiFont: UIFont { uiFontDefault }
            public var uiFontDefault: UIFont { rawValue } // Default font
            public static func toBold(_ some: UIFont) -> UIFont {
                switch some.fontName {
                case "SFProText-Regular": return UIFont(name: Fonts.sfProTextSemibold.name, size: some.pointSize)!
                case "SFProDisplay-Regular": return UIFont(name: Fonts.sfProDisplaySemibold.name, size: some.pointSize)!
                case "SFProText-Semibold": return some
                default:
                    DevTools.assert(false, message: "Not predicted [\(some.fontName)]", forceFix: false)
                }
                return some
            }
            
            public static func toItalic(_ some: UIFont) -> UIFont {
                switch some.fontName {
                case "SFProText-Regular": return UIFont(name: Fonts.sfProTextRegularItalic.name, size: some.pointSize)!
                case "SFProText-Semibold": return UIFont(name: Fonts.sfProTextSemiboldItalic.name, size: some.pointSize)!
                case "SFProDisplay-Regular": return some

                default:
                    DevTools.assert(false, message: "Not predicted [\(some.fontName)]", forceFix: false)
                }
                return some
            }

            public var font: Font { Font(uiFont) }
            public var fontDefault: Font { Font(rawValue) }
            
            public init?(rawValue: UIFont) {
                if let some = Self.allCases.first(where: { $0.rawValue == rawValue }) {
                    self = some
                } else {
                    return nil
                }
            }
            
            public var rawValue: UIFont {

                let trait = UIView().traitCollection.preferredContentSizeCategory  
                var multiplier: CGFloat = 1
                if DevTools.FeatureFlag.dev_dinamicFontSize.isEnabled {
                    // Disabled for now
                    switch trait {
                    case .unspecified: multiplier = 1
                    case .extraSmall: multiplier = 0.6
                    case .small: multiplier = 0.8
                    case .medium, .accessibilityMedium: multiplier = 1
                    case .large, .accessibilityLarge: multiplier = 1.2
                    case .extraLarge, .accessibilityExtraLarge: multiplier = 1.4
                    case .extraExtraLarge, .accessibilityExtraLarge: multiplier = 1.5
                    case .extraExtraExtraLarge, .accessibilityExtraExtraLarge: multiplier = 1.8
                    case .accessibilityExtraExtraExtraLarge: multiplier = 2
                    default: multiplier = 1
                    }
                }

                //let defaultFont = sfProTextRegular
                switch self {
                case .notApplied: return UIFont(name: Fonts.sfProTextRegular.name, size: 17.0 * multiplier)!
                         
                case .largeTitleThin: return UIFont(name: Fonts.sfCompactDisplayThin.name, size: 48.0 * multiplier)!
                case .largeTitle: return UIFont(name: Fonts.sfProDisplayRegular.name, size: 34.0 * multiplier)!
                case .title1: return UIFont(name: Fonts.sfProDisplayRegular.name, size: 28.0 * multiplier)!
                case .title2: return UIFont(name: Fonts.sfProDisplayRegular.name, size: 22.0 * multiplier)!
                case .headline: return UIFont(name: Fonts.sfProTextSemibold.name, size: 17.0 * multiplier)!
                case .body: return UIFont(name: Fonts.sfProTextRegular.name, size: 17.0 * multiplier)!
                case .bodyBold: return UIFont(name: Fonts.sfProTextSemibold.name, size: 17.0 * multiplier)!
                case .footnote: return UIFont(name: Fonts.sfProTextRegular.name, size: 13.0 * multiplier)!
                case .footnoteBold: return UIFont(name: Fonts.sfProTextSemibold.name, size: 13.0 * multiplier)!
                case .caption1: return UIFont(name: Fonts.sfProTextRegular.name, size: 12.0 * multiplier)!
                case .caption1Bold: return UIFont(name: Fonts.sfProTextSemibold.name, size: 12.0 * multiplier)!
                case .caption2: return UIFont(name: Fonts.sfProTextRegular.name, size: 11.0 * multiplier)!
                case .caption2Bold: return UIFont(name: Fonts.sfProTextSemibold.name, size: 11.0 * multiplier)!

                }
            }

            // swiftlint:disable no_UIKitAdhocConstruction random_rule_2
            public var reportView: UIView {
                func addFont(text: String, font: UIFont) {
                    let label1 = UILabel()
                    label1.text = "\(self)"
                    label1.font = font
                    label1.textColor = UIStackView.fontDefaultColor()
                    stack.addArrangedSubview(label1)
                }
                let stack = UIStackView.defaultVerticalStackView()
                var fontsToDisplay = [uiFontDefault]
                var altFonts = ""
                let toBold = FontSemanticSmart.toBold(uiFontDefault)
                if uiFontDefault.fontName != toBold.fontName {
                    fontsToDisplay.append(toBold)
                    altFonts = "\(altFonts)\(toBold.fontName) | "
                }
                let toItalic = FontSemanticSmart.toItalic(uiFontDefault)
                if uiFontDefault.fontName != toItalic.fontName {
                    fontsToDisplay.append(toItalic)
                    altFonts = "\(altFonts)\(toItalic.fontName) | "
                }
                fontsToDisplay.forEach { (some) in
                    addFont(text: "\(some)", font: some)
                }
                let lblCaptionFontBase = UILabel()
                lblCaptionFontBase.text = "Base (Regular): \(uiFont.fontName) | \(String(format: "%.1f", uiFont.pointSize))"
                lblCaptionFontBase.layoutStyle = .caption1
                lblCaptionFontBase.textAlignment = .right
                lblCaptionFontBase.textColor = UIStackView.fontDefaultColor()
                let lblCaptionFontAlternative = UILabel()
                lblCaptionFontAlternative.text = "Alt Fonts: \(altFonts)"
                lblCaptionFontAlternative.layoutStyle = .caption2
                lblCaptionFontAlternative.textAlignment = .right
                lblCaptionFontAlternative.textColor = UIStackView.fontDefaultColor()
                stack.addArrangedSubview(lblCaptionFontBase)
                stack.addArrangedSubview(lblCaptionFontAlternative)
                return stack
            }
            // swiftlint:enable no_UIKitAdhocConstruction random_rule_2
        }
    }
}

#if canImport(SwiftUI) && DEBUG
public struct Resources_PackSmartFont_Preview {
    private init() { }
    open class PreviewVC: BasePreviewVC {
        public override func loadView() {
            super.loadView()
            stackViewV.dev_loadWithSmartReport_Resources_Fonts()
        }
    }
    struct Preview: PreviewProvider {
        static var previews: some View {
            PreviewVC().asAnyView.buildPreviews()
        }
    }
}
#endif

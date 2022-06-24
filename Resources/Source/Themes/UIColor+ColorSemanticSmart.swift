//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
//
import BaseUI
import Common
import DevTools
import AppConstants

//
// MARK: - Color Set 4: Smart
//

public extension UIStackView {
    func dev_loadWithSmartReport_Resources_Colors() {
        dev_addSection(title: "\(ColorSemantic.self): \(ColorSemantic.allCases.count) values")
        ColorSemantic.allCases.forEach { (some) in
            if let reportViewAlternative = some.reportViewAlternative {
                common.add(uiview: reportViewAlternative)
            }
        }
        
        dev_addSection(title: "\(UIColor.ColorPallete.self): \(UIColor.ColorPallete.allCases.count) values")
        UIColor.ColorPallete.allCases.forEach { (some) in
            let reportView = some.reportView
            common.add(uiview: some.reportView)
            reportView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
}

public extension UIColor.ColorSemantic {
    
    // Sugar for UI elements
    
    enum Sugar {
        
        // Appears on invision, but is not an official design color -.-
        static var nonOfficialGrey1: UIColor { UIColor.colorFromRGBString("51,53,53") }     // #333535
        static var nonOfficialwhite1: UIColor { UIColor.colorFromRGBString("213,213,214") } // #D5D5D6

        public static var gradient1StartValue: UIColor {
            return CommonNameSpace.ColorScheme.current == .light ?
                UIColor.colorFromRGBString("232,234,236") : // #E8EAEC
                Sugar.nonOfficialGrey1
        }
        
        /// On the Battery section, is the background color of the charge limite view
        public static var chargeLimiteViewColor: UIColor {
            return CommonNameSpace.ColorScheme.current == .light ?
                Sugar.nonOfficialwhite1 :
                UIColor.colorFromRGBString("80,80,79") // #50504F
        }
        
        public static var gradient2StartValue: UIColor {
            return CommonNameSpace.ColorScheme.current == .light ?
                Sugar.nonOfficialwhite1 :
                Sugar.nonOfficialGrey1
        }
        
        /// Gives the oposite color scheme of the currently selected
        private static var invertedColorScheme: Common_ColorScheme {
            Common_ColorScheme.current == .light ? .dark : .light
        }

    }
    
}

public extension UIColor {
    
    #warning("Tutorial : Colors definition : ColorSemantic - Change from ligth to dark mode")
    
    //
    // semantic colors
    // https://www.hackingwithswift.com/example-code/uicolor/how-to-use-semantic-colors-to-help-your-ios-app-adapt-to-dark-mode
    indirect enum ColorSemantic: CaseIterable, ReportableColorProtocol {
                
        static var colorScheme: Common_ColorScheme = .light
                
        //
        // Cases
        //
        
        case clear       // Static Color!
        case danger      // Static Color!
        case allCool     // Static Color!

        case primary
        
        case labelPrimary
        case labelSecondary
        
        case systemPrimary
        case systemSecondary
        
        case backgroundPrimary  // Regular screens background
        case backgroundSecondary
        case backgroundGradient // Regular background shadows

        //
        // Private / Auxiliar
        //
        
        private var currenColorScheme: Common_ColorScheme {
            Common_ColorScheme.current
        }
        
        //
        // Public
        //
        
        public var rawValue: UIColor { rawValue(currenColorScheme) }
        public var uiColor: UIColor { rawValue }
        public var color: Color { Color(rawValue) }
        public func color(_ on: Common_ColorScheme) -> UIColor { rawValue(on) }
        public var colorAlternative: UIColor? { rawValue(Common_ColorScheme.alternative) }
        public var name: String { "\(self)" }
                        
        public init?(rawValue: UIColor) {
            if let some = Self.allCases.first(where: { $0.rawValue == rawValue }) {
                self = some
            } else {
                return nil
            }
        }
        
        // swiftlint:disable cyclomatic_complexity
        public func rawValue(_ on: Common_ColorScheme) -> UIColor {
                        
            let cacheKey = "\(self)_\(on)"
            if let cachedValue = ColorsCache.shared.get(key: cacheKey) as? UIColor {
                // return cached color instead of calculating the color again
                return cachedValue
            }

            var result: UIColor?
            
            switch self {
            
            case .clear: result = UIColor.clear
            case .danger: result = ColorPallete.red2.uiColor
            case .allCool: result = ColorPallete.green2.uiColor
                
            case .primary: result = ColorPallete.primary.uiColor
                            
            //
            // Label
            //
            
            case .labelPrimary: result = on == .light ?
                ColorPallete.black.uiColor :
                ColorPallete.white.uiColor
            case .labelSecondary: result = on == .light ?
                ColorPallete.black.colorFaded06 :
                ColorPallete.white.colorFaded06
                
            //
            // System
            //
            
            case .systemPrimary: result = on == .light ?
                ColorPallete.systemPrimary.colorFaded02 :
                ColorPallete.systemPrimary.colorFaded02
            case .systemSecondary: result = on == .light ?
                ColorPallete.systemPrimary.colorFaded016 :
                ColorPallete.systemPrimary.colorFaded016
                
            //
            // BackGround
            //
            
            case .backgroundPrimary: result = on == .light ?
                ColorPallete.white.uiColor:
                ColorPallete.black.uiColor
                
            case .backgroundSecondary: result = on == .light ?
                ColorPallete.silver2.uiColor:
                ColorPallete.black.uiColor
                
            case .backgroundGradient: result = on == .light ?
                UIColor.colorFromRGBString("201,208,214") :
                ColorPallete.grey2.uiColor
            }
            
            if let result = result {
                ColorsCache.shared.add(object: result, withKey: cacheKey)
                return result
            }

            return .clear
        }
        // swiftlint:enable cyclomatic_complexity
    }
}

public extension UIColor {
    static func colorWith(_ colorSemantic: ColorSemantic?,
                          _ options: [AppFontsSmartStyleOptions]? = nil,
                          _ theme: Common_ColorScheme? = nil) -> UIColor? {
        
        guard let colorSemantic = colorSemantic else {
            return nil
        }

        var theme: Common_ColorScheme? = theme
        if theme == nil {
            theme = Common_ColorScheme.current
        }
        var result = colorSemantic.color(theme!)
        if let options = options, options.contains(.fade_06) {
            result = result.alpha(0.6)
        }
        return result
    }
    
}

internal extension UIColor {
    
    #warning("Tutorial : Colors definition : ColorPallete - Dont change from ligth to dark mode")

    enum ColorPallete: CaseIterable, ReportableColorProtocol {
        
        //
        // Cases
        //
        
        case primary
        case systemPrimary

        case white
        case black
        case silver1
        case silver2
        
        case grey1
        case grey2
        
        case green1
        case green2
        case blue
        case blue2
        case red1
        case red2
        case orange
        case yellow
        
        //
        // Private / Auxiliar
        //
        
        //
        // Public
        //
        
        public static var colorScheme: Common_ColorScheme = .light
        
        public var name: String { "\(self)" }
        
        public var colorAlternative: UIColor? { nil }
        
        public var uiColor: UIColor { rawValue }
        public var color: Color { Color(uiColor) }
        
        public var colorFaded08: UIColor { uiColor.alpha(0.8) }
        public var colorFaded064: UIColor { uiColor.alpha(0.64) }
        public var colorFaded06: UIColor { uiColor.alpha(0.6) }
        public var colorFaded048: UIColor { uiColor.alpha(0.48) }
        public var colorFaded04: UIColor { uiColor.alpha(0.4) }
        public var colorFaded036: UIColor { uiColor.alpha(0.36) }
        public var colorFaded032: UIColor { uiColor.alpha(0.32) }
        public var colorFaded03: UIColor { uiColor.alpha(0.3) }
        public var colorFaded024: UIColor { uiColor.alpha(0.24) }
        public var colorFaded02: UIColor { uiColor.alpha(0.2) }
        public var colorFaded018: UIColor { uiColor.alpha(0.18) }
        public var colorFaded016: UIColor { uiColor.alpha(0.16) }
        public var colorFaded012: UIColor { uiColor.alpha(0.12) }
        public var colorFaded008: UIColor { uiColor.alpha(0.08) }
        
        public var colorSwiftUI: SwiftUI.Color { Color(rawValue) }
        
        public init?(rawValue: UIColor) {
            if let some = Self.allCases.first(where: { $0.rawValue == rawValue }) {
                self = some
            } else {
                return nil
            }
        }
        
        public var rawValue: UIColor {
            switch self {
            case .primary: return UIColor.colorFromRGBString("214,230,0")         // #D6E600 (Lime)
            case .white: return UIColor.colorFromRGBString("255,255,255")         // #FFFFFF
            case .black: return UIColor.colorFromRGBString("20,20,19")            // #141413
            case .grey1: return UIColor.colorFromRGBString("89,89,89")            // #595959
            case .grey2: return UIColor.colorFromRGBString("48,50,51")            // #303233
            case .silver1: return UIColor.colorFromRGBString("150,157,163")       // #969DA3
            case .silver2: return UIColor.colorFromRGBString("240,241,242")       // #F0F1F2
            case .green1: return UIColor.colorFromRGBString("172,239,183")        // #ACE6B7
            case .green2: return UIColor.colorFromRGBString("50,215,75")          // #32D74B
            case .blue: return UIColor.colorFromRGBString("125,207,227")          // #7DCFE3
            case .blue2: return UIColor.colorFromRGBString("10,132,255")          // #0A84FF
            case .red1: return UIColor.colorFromRGBString("230,156,152")          // #E69C98
            case .red2: return UIColor.colorFromRGBString("230,64,64")            // #E64040
            case .orange: return UIColor.colorFromRGBString("246,190,49")         // #F6BE31
            case .yellow: return UIColor.colorFromRGBString("255,204,0")          // #FFCC00
            
            case .systemPrimary: return UIColor.colorFromRGBString("120,124,128") // #787880
            
            }
        }
    }
}

private struct ColorsCache {
    private init() {}
    public static let shared = ColorsCache()
    private var _cache = NSCache<NSString, AnyObject>()
    public func add(object: AnyObject, withKey: String) {
        objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
        _cache.setObject(object as AnyObject, forKey: withKey as NSString)
    }
    public func get(key: String) -> AnyObject? {
        objc_sync_enter(_cache); defer { objc_sync_exit(_cache) }
        if let object = _cache.object(forKey: key as NSString) { return object }
        return nil
    }
}

#if canImport(SwiftUI) && DEBUG
public struct Resources_PackSmartColors_Preview {
    private init() { }
    open class PreviewVC: BasePreviewVC {
        public override func loadView() {
            super.loadView()
            stackViewV.dev_loadWithSmartReport_Resources_Colors()
        }
    }
    struct Preview: PreviewProvider {
        static var previews: some View {
            PreviewVC().asAnyView.buildPreviews()
        }
    }
}
#endif

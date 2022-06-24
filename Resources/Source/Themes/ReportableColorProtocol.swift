//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import Common
import DevTools

public protocol ReportableColorProtocol {
    var name: String { get }
    var color: Color { get }
    var uiColor: UIColor { get }
    var colorAlternative: UIColor? { get }
    var reportView: UIView { get }
    var reportViewAlternative: UIView? { get } // For dark mode
}

public extension ReportableColorProtocol {
    var reportViewAlternative: UIView? {
        let stackView = UIStackView.defaultVerticalStackView(0, 0)
        let have2Colors = uiColor.rgbString != (colorAlternative ?? UIColor.random).rgbString
        if have2Colors {
            let reportView1 = reportView(color: uiColor, caption: "(\(Common_ColorScheme.current) mode)".uppercased())
            let reportView2 = reportView(color: colorAlternative, caption: "(\(Common_ColorScheme.alternative) mode)".uppercased())
            let marginView1 = UIView()
            let marginView2 = UIView()
            let marginView3 = UIView()
            stackView.addArrangedSubview(marginView1)
            stackView.addArrangedSubview(reportView1!)
            stackView.addArrangedSubview(marginView2)
            stackView.addArrangedSubview(reportView2!)
            stackView.addArrangedSubview(marginView3)
            marginView1.heightAnchor.constraint(equalToConstant: 2).isActive = true
            marginView2.heightAnchor.constraint(equalToConstant: 4).isActive = true
            marginView3.heightAnchor.constraint(equalToConstant: 2).isActive = true
            stackView.addBorder(width: 1, color: .darkGray, animated: false)
        } else {
            let reportView = reportView(color: uiColor, caption: "(\(Common_ColorScheme.current) and \(Common_ColorScheme.alternative) mode)".uppercased())
            let marginView1 = UIView()
            let marginView2 = UIView()
            stackView.addArrangedSubview(marginView1)
            stackView.addArrangedSubview(reportView!)
            stackView.addArrangedSubview(marginView2)
            marginView1.heightAnchor.constraint(equalToConstant: 2).isActive = true
            marginView2.heightAnchor.constraint(equalToConstant: 2).isActive = true
            stackView.addBorder(width: 1, color: .darkGray, animated: false)
        }
        return stackView
    }
    
    var reportView: UIView {
        let stack  = UIStackView.defaultVerticalStackView(0, 0)
        let hStack1 = UIStackView.defaultHorizontalStackView(0, 0)
        let hStack2 = UIStackView.defaultHorizontalStackView(0, 0)
        let hStack3 = UIStackView.defaultHorizontalStackView(0, 0)
        let v1 = reportView(color: uiColor, caption: "")
        let v_08 = reportView(color: uiColor.alpha(0.8, over: .white), caption: "", compact: true)
        let v_06 = reportView(color: uiColor.alpha(0.6, over: .white), caption: "", compact: true)
        let v_04 = reportView(color: uiColor.alpha(0.4, over: .white), caption: "", compact: true)
        let v_02 = reportView(color: uiColor.alpha(0.2, over: .white), caption: "", compact: true)
        //let v_016 = reportView(color: uiColor.alpha(0.16, over: .white), caption: "", compact: true)
        //let v_012 = reportView(color: uiColor.alpha(0.12, over: .white), caption: "", compact: true)
        //let v_008 = reportView(color: uiColor.alpha(0.08, over: .white), caption: "", compact: true)
        [v_08, v_06, v_04, v_02/*, v_016, v_012, v_008*/].forEach { ($0 as? UILabel)?.textAlignment = .center }
        [v_08, v_06, v_04, v_02].compactMap { $0 }.forEach { hStack2.addArrangedSubview($0) }
        //[v_016, v_012, v_008].compactMap { $0 }.forEach { hStack3.addArrangedSubview($0) }
        [v1!, hStack1, hStack2, hStack3].forEach { stack.addArrangedSubview($0) }
        return stack
    }
    
    // swiftlint:disable no_UIKitAdhocConstruction
    func reportView(color: UIColor?, caption: String, compact: Bool = false) -> UIView? {
        guard let color = color else { return nil }
        let stack  = UIStackView.defaultHorizontalStackView(0, 0)
        stack.distribution = .fill
        let label = UILabel()
        label.numberOfLines = 0
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        if color.cgColor.components!.count == 2 {
            r = color.cgColor.components![0] * 255
            g = color.cgColor.components![0] * 255
            b = color.cgColor.components![0] * 255
            a = color.cgColor.components![1]
        } else if color.cgColor.components!.count >= 3 {
            r = color.cgColor.components![0] * 255
            g = color.cgColor.components![1] * 255
            b = color.cgColor.components![2] * 255
            if color.cgColor.components?.count == 4 {
                a = color.cgColor.components![3]
            }
        }
        let hexValue = String(format: "%02X", Int(r)) + String(format: "%02X", Int(g)) + String(format: "%02X", Int(b))
        let rgbValue = color.rgbString
        if compact {
            label.layoutStyle = .caption2
            label.text = "\(rgbValue)\n #\(hexValue)"
        } else {
            label.layoutStyle = .caption1
            if a < 1 {
                var matchColor = ""
                let overW = UIColor.colorFromRGBString("247,247,247")
                let overWhite = UIColor.colorFromRGBString("\(Int(r)),\(Int(g)),\(Int(b))").alpha(a, over: overW)
                let overBlack = UIColor.colorFromRGBString("\(Int(r)),\(Int(g)),\(Int(b))").alpha(a, over: .black)
                // Have alpha! Lets show the computed color also
                matchColor = "Solid: OverW:[\(overWhite.rgbString)], OverB:[\(overBlack.rgbString)]"
                ColorPallete.allCases.forEach { (some) in
                    if some.rawValue == overWhite {
                        matchColor = "Matchs with [\(some) : \(overWhite.rgbString)]"
                    } else if some.rawValue == overBlack {
                        matchColor = "Matchs with [\(some) : \(overBlack.rgbString)]"
                    }
                }
                label.text = " ID: .\(name)\n Value: rgb(\(rgbValue)) | hex(#\(hexValue))\n \(matchColor)\n \(caption)"
            } else {
                label.text = " ID: .\(name)\n Value: rgb(\(rgbValue)) | hex(#\(hexValue))\n \(caption)"
            }
        }
        
        label.textColor = UIStackView.fontDefaultColor()
        let colorView = UIView()
        colorView.backgroundColor = color
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(colorView)
        colorView.layouts.width(50)
        colorView.layouts.height(50)
        colorView.layouts.right(to: stack, offset: -2)
        colorView.addBorder(width: 1, color: color.inverse, animated: false)
        if compact {
            label.textColor = color.inverse
            label.backgroundColor = color
            return label
        } else {
            return stack
        }
    }
    // swiftlint:enable no_UIKitAdhocConstruction_1
}

//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
import os.log
//
import Common
import Toast

public struct DevTools {
    public static var onDevMode: Bool {
        guard !onTargetProduction else { return false }
        return onSimulator || onTargetDev // Dont change. QA team is using the FFlags screen and this is the lock
    }
    public static var onSimulator: Bool { Common_Utils.onSimulator }
    public static var onDebug: Bool { Common_Utils.onDebug }
    public static var onRelease: Bool { Common_Utils.onRelease }
    public static var onUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    public static var targetEnv: String {
        guard let value = (Bundle.main.infoDictionary?["TARGET_ENVIRONMENT"] as? String)?
            .replacingOccurrences(of: "\\", with: "") else {
            return ""
        }
        return value
    }
    public static var onTargetMock: Bool { targetEnv.lowercased() == "mock" }
    public static var onTargetDev: Bool { targetEnv.lowercased() == "dev" }
    public static var onTargetQA: Bool {targetEnv.lowercased() == "qa" }
    public static var onTargetProduction: Bool { targetEnv.lowercased() == "production" }
    
    public static var `false`: Bool { false }
    public static var `true`: Bool { true }

    public static func assertFailure(_ message:@autoclosure() -> String,
                                     function: StaticString = #function,
                                     forceFix: Bool,
                                     file: StaticString = #file,
                                     line: Int = #line) {
        DevTools.assert(false, message: message(), forceFix: forceFix, function: function, file: file, line: line)
    }
    
    public static func paint(_ view: UIView, _ enabled: Bool, _ method: Int) {
        paint(view, UIColor.random.alpha(0.3), enabled, method)
    }
    
    public static func report(_ view: UIView) -> String {
        let allViews = view.allSubviewsRecursive()
        var report: String = "Count: \(allViews.count)"
        var index = 0
        allViews.forEach { (view) in
            var thisView: String = "[\(index)] : \(view.className)"
            if let label = view as? UILabel {
                if let text = label.text {
                    thisView += "text:\(text)\n"
                }
            }
            if let button = view as? UIButton {
                if let text = button.titleLabel?.text {
                    thisView += "text:\(text)\n"
                }
            }
            if let accessibilityIdentifier = view.accessibilityIdentifier {
                thisView += "accessibilityIdentifier:\(accessibilityIdentifier)\n"
            }
            if !thisView.isEmpty {
                report += "\(thisView)\n"
            }
            index += 1
        }
        return report
    }
    
    public static func paint(_ view: UIView,
                             _ mainViewBackgroundColor: UIColor?,
                             _ enabled: Bool,
                             _ method: Int) {
        guard onDevMode else { return }
        guard enabled else { return }

        if method == 1 {
            view.layer.borderColor = UIColor.random.cgColor
            view.layer.borderWidth = 1
            view.allSubviewsRecursive().forEach { (some) in
                some.layer.borderColor = UIColor.random.cgColor
                some.layer.borderWidth = 1
            }
        } else if method == 2 {
            view.allSubviewsRecursive().forEach { (some) in
                some.backgroundColor = UIColor.random.alpha(0.3)
            }
        } else {
            paint(view, enabled, 1)
            paint(view, enabled, 2)
        }
        if let mainViewBackgroundColor = mainViewBackgroundColor {
            view.backgroundColor = mainViewBackgroundColor
            view.superview?.backgroundColor = mainViewBackgroundColor.inverse
        }
    }
    
    public static func assert(_ value: @autoclosure() -> Bool,
                              message: @autoclosure() -> String="",
                              forceFix: Bool = false,
                              function: StaticString = #function,
                              file: StaticString = #file,
                              line: Int = #line) {
        guard onDebug else { return }
        if !value() {
            if DevTools.onDevMode {
                let filePrety = "\(file)".components(separatedBy: "/").last!
                // swiftlint:disable logs_rule_1
                print("\n\nAssert condition not meeted! \(message()) | [\(function)] @ [\(filePrety)]\n")
                // swiftlint:enable logs_rule_1
            }
            Log.error("Assert condition not meeted! \(message())",
                      .generic,
                      function: "\(function)",
                      file: "\(file)",
                      line: line)
            if forceFix && !DevTools.onTargetProduction {
                fatalError("Fix me \(file)|\(function)|\(line)")
            }
        }
    }
        
    fileprivate static var toastCount: Int = 0

    // Displays a message for developers (only if is simulador or debug mode)
    public static func makeToastForDevTeam(_ debugMessage: String,
                                           function: StaticString = #function,
                                           file: StaticString = #file,
                                           line: Int = #line) {
        guard !DevTools.onTargetProduction else { return }
        guard DevTools.FeatureFlag.dev_toastsMessages.isEnabled else { return }
        Self.toastCount += 1
        let senderCodeId = Common_Utils.senderCodeId("\(function)", file: "\(file)", line: line)
        var style = ToastStyle()
        style.cornerRadius = 5
        style.displayShadow = true
        style.backgroundColor = UIColor.white.alpha(0.5)
        style.messageColor = .black
        let message = "Toast \(Self.toastCount)\n\(Date())\n\n\(debugMessage)\n\n\(senderCodeId)"
        UIViewController.topViewController?.view.makeToast(message, duration: 5, position: .center, style: style)
    }
}

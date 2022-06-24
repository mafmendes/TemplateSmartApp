//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
//
import Common

public extension DevTools {
    
    struct Log {
        
        private init() { }
        private static let prefixMax = 3000
        private static var counter = 0
        
        public enum Tag {
            case generic           // Misc....
            case view              // For Views
            case viewModel         // For ViewModels
            case viewController    // For ViewControllers
            case useCase           // For UseCases
            case smartSDK          // For SmartSDK
            case pushNotifications // For Push Notifications
            case repository        // For CoreData (repositories)
        }
        
        public static func setup() {

        }
        
        static func canLog(_ any: Any?, _ tag: Tag) -> Bool {
            guard any != nil else { return false }  // Nothing to log
            
            // Log by log type
            switch tag {
            case .generic:           return DevTools.FeatureFlag.dev_canLog_generic.isEnabled
            case .view:              return DevTools.FeatureFlag.dev_canLog_view.isEnabled
            case .viewModel:         return DevTools.FeatureFlag.dev_canLog_viewModel.isEnabled
            case .viewController:    return DevTools.FeatureFlag.dev_canLog_viewController.isEnabled
            case .useCase:           return DevTools.FeatureFlag.dev_canLog_useCase.isEnabled
            case .smartSDK:          return DevTools.FeatureFlag.dev_canLog_smartSDK.isEnabled
            case .pushNotifications: return DevTools.FeatureFlag.dev_canLog_pushNotifications.isEnabled
            case .repository:        return DevTools.FeatureFlag.dev_canLog_repositories.isEnabled
            }
        }
        
        public static func deleteLogs() {
            CommonNameSpace.Logger.StorageUtils.deleteLogs() }
        public static func retrieveLogs(full: Bool) -> String {
            guard var logs = CommonNameSpace.Logger.StorageUtils.retrieveLogs() else {
                return ""
            }
            if !full {
                let max = 100000
                if logs.count > max {
                    logs = String(logs.dropFirst(logs.count - max))

                }
            }
            return logs
        }
        private static func store(log: String) { CommonNameSpace.Logger.StorageUtils.appendToFileStart(log) }
        
        // swiftlint:disable logs_rule_1

        /// Use for user interactions, protocol extension, generic app flow
        public static func trace(_ any: Any?, _ tag: Tag,
                                 function: String = #function, file: String = #file, line: Int = #line) {
            guard let any = any else { return }
            let log = prettyPrinted(log: "\(any)", type: "🟦⬜⬜⬜ Trace 🟦⬜⬜⬜", tag: tag, function: function, file: file, line: line)
            if DevTools.FeatureFlag.dev_minLogLevel_trace.isEnabled && canLog(any, tag) {
                print(log)
                if DevTools.FeatureFlag.dev_fileLogger.isEnabled {
                    store(log: log)
                }
            }
        }
        
        /// Generic logs
        public static func debug(_ any: Any?, _ tag: Tag,
                                 function: String = #function, file: String = #file, line: Int = #line) {
            guard let any = any else { return }
            let log = prettyPrinted(log: "\(any)", type: "🟦🟦⬜⬜ Debug 🟦🟦⬜⬜", tag: tag, function: function, file: file, line: line)

            if DevTools.FeatureFlag.dev_minLogLevel_debug.isEnabled || canLog(any, tag) {
                print(log)
                if DevTools.FeatureFlag.dev_fileLogger.isEnabled {
                    store(log: log)
                }
            }
        }
        
        /// Things shouldnt be happening, but that the app can recover. Its not a issue today, but can turn into one
        public static func warning(_ any: Any?, _ tag: Tag,
                                   function: String = #function, file: String = #file, line: Int = #line) {
            guard let any = any else { return }
            let log = prettyPrinted(log: "\(any)", type: "🟨🟨🟨⬜ Warning 🟨🟨🟨⬜", tag: tag, function: function, file: file, line: line)

            if DevTools.FeatureFlag.dev_minLogLevel_warning.isEnabled || canLog(any, tag) {
                print(log)
                if DevTools.FeatureFlag.dev_fileLogger.isEnabled {
                    store(log: log)
                }
            }
        }
        
        /// Things that must be fixed and shouldnt happen. This logs will allways be printed (unlesse Prod apps)
        public static func error(_ any: Error, _ tag: Tag,
                                 function: String = #function, file: String = #file, line: Int = #line) {
            DevTools.Log.error("\(any)", tag, function: function, file: file, line: line)
        }
        
        /// Things that must be fixed and shouldnt happen. This logs will allways be printed (unlesse Prod apps)
        public static func error(_ any: String, _ tag: Tag,
                                 function: String = #function, file: String = #file, line: Int = #line) {
            // We cant disable this logs, unless is Production app
            guard !DevTools.onTargetProduction else { return }
            let log = prettyPrinted(log: "\(any)", type: "🟥🟥🟥🟥 Error 🟥🟥🟥🟥", tag: tag, function: function, file: file, line: line)
            print(log)
            if DevTools.FeatureFlag.dev_fileLogger.isEnabled {
                store(log: log)
            }
        }
    
        /// Things that will allways be print. This logs will allways be printed (unlesse Prod apps)
        public static func mandatory(_ any: String,
                                     function: String = #function, file: String = #file, line: Int = #line) {
            // We cant disable this logs, unless is Production app
            guard !DevTools.onTargetProduction else { return }
            counter += 1
            let log = "🟢 Log_\(counter) @ \(Date.utcNow) - \(any)\n".replace(" +0000", with: "").replace("Optional", with: "")
            print(log)
            if DevTools.FeatureFlag.dev_fileLogger.isEnabled || true { // Mandatory messages are allways stored
                store(log: log)
            }
        }
        
        private static func prettyPrinted(log: String, type: String, tag: Tag,
                                          function: String = #function, file: String = #file, line: Int = #line) -> String {
            counter += 1
                    
            let senderCodeId   = Common_Utils.senderCodeId(function, file: file, line: line)
            let messageToPrint = log
            let title          = "Log_\(counter) @ \(Date.utcNow)"
            let separator = "##################"
            var logMessage = ""
            logMessage = "\(logMessage)\n\(separator)\(separator)\n"
            logMessage = "\(logMessage)# Title:  \(title)\n"
            logMessage = "\(logMessage)# Type:   \(type) | \(tag)\n"
            logMessage = "\(logMessage)# Sender: \(senderCodeId)\n"
            logMessage = "\(logMessage)↓ ↓ ↓ ↓\n"
            if messageToPrint.hasSuffix("\n") {
                logMessage = "\(logMessage)\(messageToPrint)"
            } else {
                logMessage = "\(logMessage)\(messageToPrint)\n"
            }
            logMessage = "\(logMessage)↑ ↑ ↑ ↑\n"

            return logMessage
        }
        // swiftlint:disable logs_rule_1
    }
}

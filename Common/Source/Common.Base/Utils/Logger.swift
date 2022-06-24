//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable logs_rule_1

// MARK: - Logger (Public)

extension CommonNameSpace {
    
    public struct Logger {
        private init() {}
        
        private static var _debugCounter: Int = 0
        public static func cleanStoredLogs() {
            StorageUtils.deleteLogs()
        }
        
        public static func debug(_ message: Any?,
                                 function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let prefix = "# Type : Debug"
            private_print("\(prefix)\n\n\(message!)", function: function, file: file, line: line)
        }
        
        public static func info(_ message: Any?,
                                function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let prefix = "# Type : Info"
            private_print("\(prefix)\n\n\(message!)", function: function, file: file, line: line)
        }
        
        public static func warning(_ message: Any?,
                                   function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let prefix = "# Type: Warning"
            private_print("\(prefix)\n\n\(message!)", function: function, file: file, line: line)
        }
        
        public static func error(_ message: Any?,
                                 shouldCrash: Bool = false,
                                 function: String = #function, file: String = #file, line: Int = #line) {
            guard message != nil else { return }
            let prefix = "# Type : Error"
            private_print("\(prefix)\n\n\(message!)", function: function, file: file, line: line)
        }
        
        //
        // Log to console/terminal
        //
        
        public static func prettyPrinted(_ message: @autoclosure () -> String,
                                         function: String = #function,
                                         file: String = #file,
                                         line: Int = #line) -> String {
            _debugCounter     += 1
            let senderCodeId   = Common_Utils.senderCodeId(function, file: file, line: line)
            let messageToPrint = message().trim
            let date           = Date.utcNow
            let logMessage     = """
            \n###########################
            # Log_\(_debugCounter) @ \(date)
            # \(senderCodeId)
            \(messageToPrint)
            """
            return logMessage
        }
        
        private static func private_print(_ message: @autoclosure () -> String,
                                          function: String = #function,
                                          file: String = #file,
                                          line: Int = #line) {
            
            // When performed on physical device, NSLog statements appear in the device's console whereas
            // print only appears in the debugger console.
            
            let logMessage = prettyPrinted(message(), function: function, file: file, line: line)
            
            StorageUtils.appendToFileEnd(logMessage)
            
            if !Common_Utils.isSimulator {
                NSLog("%@\n", logMessage)
            } else {
                // NAO APAGAR O "Swift", senao a app pensa que é a esta mm funcao e entra em loop
                Swift.print(logMessage+"\n")
            }
        }
    }
}

// MARK: - Logger (Private)

public extension CommonNameSpace.Logger {
    
    struct StorageUtils {
        
        fileprivate static var logFile: URL? {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
            let logFile =  documentsDirectory.appendingPathComponent("\(CommonNameSpace.self).\(CommonNameSpace.Logger.self).log")
            return logFile
        }
        
        public static func deleteLogs() {
            guard let logFile = logFile else {  return }
            guard FileManager.default.isDeletableFile(atPath: logFile.path) else { return }
            try? FileManager.default.removeItem(atPath: logFile.path)
        }
        
        public static func retrieveLogs() -> String? {
            guard let logFile = logFile else {  return nil }
            return try? String(contentsOf: logFile, encoding: String.Encoding.utf8)
        }
        
        public static func appendToFileStart(_ log: String) {
            guard let logFile = logFile else {  return }
            let currentFile = retrieveLogs() ?? ""
            guard let data = ("\(log)\n\(currentFile)").data(using: String.Encoding.utf8) else { return }
            if FileManager.default.fileExists(atPath: logFile.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                    defer {
                        fileHandle.closeFile()
                    }
                    fileHandle.write(data)
                }
            } else {
                try? data.write(to: logFile, options: .atomicWrite)
            }
        }
        
        public static func appendToFileEnd(_ log: String) {
            guard let logFile = logFile else {  return }
            guard let data = ("\(log)\n").data(using: String.Encoding.utf8) else { return }
            if FileManager.default.fileExists(atPath: logFile.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                    defer {
                        fileHandle.closeFile()
                    }
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                }
            } else {
                try? data.write(to: logFile, options: .atomicWrite)
            }
        }
    }
}

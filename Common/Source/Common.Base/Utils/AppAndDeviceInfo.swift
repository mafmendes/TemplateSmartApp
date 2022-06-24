//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

// MARK: - iOS/MacOs

extension CommonNameSpace {

    public struct AppAndDeviceInfo {
        private init() {}

        public static var appInfo: [String: String] {
            var result = [String: String]()
            result["version"]    = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
            result["identifier"] = "\(Bundle.main.bundleIdentifier!)"
            return result
        }

        public static var isSimulator: Bool {
            #if targetEnvironment(simulator)
            return true
            #else
            return false
            #endif
        }
    }
}

// MARK: - iOS

extension CommonNameSpace.AppAndDeviceInfo {
    public static var appOnBackground: Bool {
        let appState = UIApplication.shared.applicationState
        if appState == .background || appState == .inactive {
            // Inactive - Quando temo o menu das pushnotifications aberto (por exemplo)
            return true
        }
        return false
    }

    public enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS_11Pro = "iPhone X, iPhone XS, iPhone 11 Pro"
        case iPhone_XR_11 = "iPhone XR or iPhone11"
        case iPhone_XSMax_11ProMAx = "iPhone XS Max, 11 Pro Max"
        case unknown
    }

    public static var hasNotch: Bool { return iPhoneX }

    public static var iPhoneX: Bool { return iPhoneType == .iPhones_X_XS_11Pro || iPhoneType == .iPhone_XR_11 || iPhoneType == .iPhone_XSMax_11ProMAx }

    public static var iPadDevice: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    public static var iPhoneDevice: Bool { UIDevice.current.userInterfaceIdiom == .phone }

    public static var iPhoneType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960 : return .iPhones_4_4S
        case 1136: return .iPhones_5_5s_5c_SE
        case 1334: return .iPhones_6_6s_7_8
        case 1792: return .iPhone_XR_11
        case 1920, 2208: return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436: return .iPhones_X_XS_11Pro
        case 2688: return .iPhone_XSMax_11ProMAx
        default  : return .unknown
        }
    }

    public static var isInLowPower: Bool {
        let processInfo = ProcessInfo.processInfo
        if #available(iOS 9.0, *) {
            if processInfo.isLowPowerModeEnabled {
                return true
            }
        }
        return false
    }

    public static var uuid: String { UIDevice.current.identifierForVendor!.uuidString }

    public static var deviceInfo: [String: String] {
        var result = [String: String]()
        result["uuid"]          = "\(uuid)"
        result["modelName"]         = UIDevice.modelName
        result["model"]             = "\(UIDevice.current.model)"
        result["systemVersion"]     = "\(UIDevice.current.systemVersion)"
        result["OperatingSystem"]   = "\(ProcessInfo().operatingSystemVersionString)"
        result["Screen"]            = "\(UIScreen.main.nativeBounds.height)x\(UIScreen.main.nativeBounds.height)"
        result["iPhoneType"]        = "\(iPhoneType)"
        result["machineNameInfo"]   = UIDevice.machineNameInfo
        return result
    }
}

//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import Common

public extension DevTools {
        
    enum FeatureFlag: String, Identifiable, CaseIterable {
              
        case dev_fileLogger               = "Can Logs: Can log to file"

        case dev_canLog_generic           = "Can Log Family : Generic"
        case dev_canLog_view              = "Can Log Family : View"
        case dev_canLog_viewModel         = "Can Log Family : ViewModel"
        case dev_canLog_viewController    = "Can Log Family : ViewController"
        case dev_canLog_useCase           = "Can Log Family : UseCase"
        case dev_canLog_smartSDK          = "Can Log Family : SmartSDK"
        case dev_canLog_pushNotifications = "Can Log Family : Push Notifications"
        case dev_canLog_repositories      = "Can Log Family : Repositories"

        case dev_minLogLevel_trace = "Logs Level: Trace"
        case dev_minLogLevel_debug = "Logs Level: Debug"
        case dev_minLogLevel_info = "Logs Level: Info"
        case dev_minLogLevel_warning = "Logs Level: Warning"
        case dev_minLogLevel_error = "Logs Level: Error"
        case dev_toastsMessages = "Logs : Debug Toasts"
        
        case dev_dinamicFontSize = "MISC : dinamicFontSize"

        public var id: String { rawValue }

        public var title: String { "\(self.rawValue) enabled" }
        
        public var isDisabled: Bool { !isEnabled }
        
        public var isEnabled: Bool {
            let value = UserDefaults.standard.string(forKey: rawValue)
            let exists = value != nil
            if exists {
                return value == "true"
            } else {
                return defaultValue
            }
        }
        
        public func toggle() -> Bool {
            UserDefaults.standard.setValue(isEnabled ? "false" : "true", forKey: rawValue)
            UserDefaults.standard.synchronize()
            return isEnabled
        }
        
        public var defaultValue: Bool {
            switch self {
                
            case .dev_fileLogger: return false

            case .dev_toastsMessages:      return false
            case .dev_dinamicFontSize:     return false
            case .dev_minLogLevel_trace:   return false
            case .dev_minLogLevel_debug:   return false
            case .dev_minLogLevel_info:    return false
            case .dev_minLogLevel_warning: return false
            case .dev_minLogLevel_error:   return false
                
            case .dev_canLog_generic:           return false
            case .dev_canLog_view:              return false
            case .dev_canLog_viewModel:         return false
            case .dev_canLog_viewController:    return false
            case .dev_canLog_useCase:           return false
            case .dev_canLog_smartSDK:          return false
            case .dev_canLog_pushNotifications: return false
            case .dev_canLog_repositories:      return false
            }
        }
    }
}

//
// MARK: - Previews
//

public struct DevTools_Previews_FeatureFlag {
    
    struct ToggleWithStateV2: View {
        
        // @State is view’s internal state, owned by the view and should only be updated by it.
        // For information only UI relevant, not persisted and has no impact on the logic of the app
        @State var isOn: Bool = false
        var featureFlag: DevTools.FeatureFlag
        public init(featureFlag: DevTools.FeatureFlag) {
            self.featureFlag = featureFlag
        }
        public var body : some View {
            VStack {
                Toggle("\(featureFlag.title)", isOn: $isOn.didSet { _ in
                    _ = featureFlag.toggle()
                })
            }.onAppear {
                isOn = featureFlag.isEnabled
            }
        }
    }
    
    public struct Preview: PreviewProvider {
        public static var previews: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(DevTools.FeatureFlag.allCases) { flag in
                        ToggleWithStateV2(featureFlag: flag)
                    }
                    Spacer()
                }.padding()
            }
        }
    }
}

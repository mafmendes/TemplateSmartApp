//
//  Created by Santos, Ricardo Patricio dos  on 20/04/2021.
//

import Foundation
import SwiftUI
import Combine
//
import Common
import DevTools
import BaseUI
import AppConstants
import Resources
import AppDomain

public typealias ToggleWithStateV1 = App_Designables_SwiftUI.ToggleWithStateV1
public typealias ToggleWithStateV2 = App_Designables_SwiftUI.ToggleWithStateV2

public extension App_Designables_SwiftUI {
    struct ToggleWithStateV1: View {
        
        // @State is view’s internal state, owned by the view and should only be updated by it.
        // For information only UI relevant, not persisted and has no impact on the logic of the app
        @State var isOn: Bool = false
        let title: String
        public var body : some View {
            Toggle(title, isOn: $isOn.didSet { (state) in
                DevTools.Log.debug(state, .generic)
            })
        }
    }
    
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
                Toggle("\(featureFlag.title)", isOn: $isOn.didSet { (_) in
                    _ = featureFlag.toggle()
                })
            }.onAppear {
                isOn = featureFlag.isEnabled
            }
        }
    }
}

//
// MARK: - Previews
//

#if canImport(SwiftUI) && DEBUG
public struct Designables_Previews_ToggleWithState {
    public struct Preview: PreviewProvider {
        public static var previews: some View {
            VStack {
                ToggleWithStateV1(isOn: true, title: "T1")
                ToggleWithStateV2(featureFlag: .dev_dinamicFontSize)
                Spacer()
            }.padding()
        }
    }
}
#endif

//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import SwiftUI

//
// MARK: - Debug
//

public extension View {

    // https://stackoverflow.com/questions/56517813/how-to-print-to-xcode-console-in-swiftui
    func debugPrint(_ vars: Any..., function: String=#function) -> some View {
        #if DEBUG
        let wereWasIt = function
        // swiftlint:disable logs_rule_1
        for some in vars { print("\(some) @ [\(wereWasIt)]") }
        // swiftlint:enable logs_rule_1
        return self
        #else
        return self
        #endif
    }

    func debugPrintOnReload(ifCondition: Bool, id: String, function: String=#function) -> some View {
        #if DEBUG
        return Group {
            if !ifCondition {
                self.erased
            } else {
                debugPrint("[\(id)] was reloaded at [\(Date())]", function: function)
            }
        }.erased
        #else
        return self
        #endif
    }
    
    func debugPrintOnReload(id: String, function: String=#function) -> some View {
        debugPrint("[\(id)] was reloaded at [\(Date())]", function: function)
    }

}

//
// MARK: - Previews
//

public extension View {

    var buildPreviewPhone11: some SwiftUI.View {
        previewDevice("iPhone 8").previewDisplayName("Default - iPhone11")
    }

    var buildPreviewPhone8: some SwiftUI.View {
        previewDevice("iPhone 8").previewDisplayName("Default - iPhone8")
    }

    var buildPreviewDark: some SwiftUI.View {
        environment(\.colorScheme, .dark).previewDisplayName("Dark")
    }

    func buildPreviews(full: Bool = false) -> some SwiftUI.View {
        Group {
            if full {
                Group {
                    environment(\.colorScheme, .light).previewDisplayName("Light")
                    environment(\.colorScheme, .dark).previewDisplayName("Dark")
                }
                Group {
                    environment(\.sizeCategory, .small).previewDisplayName("Size_Small")
                    environment(\.sizeCategory, .large).previewDisplayName("Size_Large")
                    environment(\.sizeCategory, .extraLarge).previewDisplayName("Size_ExtraLarge")
                }
                /*Group {
                    //previewDevice("iPhone 8").previewDisplayName("iPhone8")
                   // previewDevice("iPhone 9").previewDisplayName("iPhone9")
                    previewDevice("iPhone 11").previewDisplayName("iPhone11")
                    previewDevice("iPhone 11 Pro").previewDisplayName("iPhone11 Pro")
                    previewDevice("iPhone 11 Pro Max").previewDisplayName("iPhone11 Pro Max")
                    previewDevice("iPhone 12").previewDisplayName("iPhone12")
                    previewDevice("iPhone 12 Pro").previewDisplayName("Default - iPhone12")
                    previewDevice("iPhone 12 Pro Max").previewDisplayName("Default - iPhone12 Max")
                }*/
            } else {
                previewDisplayName("Default")
            }
        }
    }
}

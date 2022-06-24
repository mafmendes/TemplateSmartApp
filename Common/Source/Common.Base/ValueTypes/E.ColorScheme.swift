//
//  Created by Ricardo Santos on 22/02/2021.
//

import Foundation
import UIKit

public extension CommonNameSpace {
    enum ColorScheme: String, CaseIterable {
        
        public init?(rawValue: String) {
            if let some = Self.allCases.first(where: { $0.rawValue.lowercased() == rawValue.lowercased() }) {
                self = some
            } else {
                return nil
            }
        }
        
        case light
        case dark
        
        public static var current: Common_ColorScheme {
            UIView().traitCollection.userInterfaceStyle == .dark ? .dark : .light
        }
        
        public static var alternative: Common_ColorScheme {
            current == .dark ? .light: .dark
        }
    }
}

//
//  Created by Ricardo Santos on 15/03/2021.
//

import Foundation
import SwiftUI

public extension Color {
    static var random: Color {
        func random() -> Double {
            return Double(arc4random()) / Double(UInt32.max)
        }
        return Color(red: random(), green: random(), blue: random())
    }
}

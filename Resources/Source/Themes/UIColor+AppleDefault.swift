//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
//
import Common

public extension UIColor {

    enum AppleDefault: CaseIterable, ReportableColorProtocol {

        case black
        case white
        case gray
        case red
        case green
        case blue
        case orange
        case yellow
        case lightGray
        case darkGray

        case systemIndigo
        case systemTeal
        case systemPurple
        case systemPink
        case systemYellow
        case systemOrange
        case systemRed
        case systemGreen
        case systemBlue
        case systemGray
        case systemGray2
        case systemGray3
        case systemGray4
        case systemGray5
        case systemGray6

        case lightText
        case darkText
        case label
        case secondaryLabel
        case tertiaryLabel
        case quaternaryLabel
        case link
        case placeholderText
        case separator
        case opaqueSeparator

        case systemBackground
        case secondarySystemBackground
        case tertiarySystemBackground
        case systemGroupedBackground
        case secondarySystemGroupedBackground
        case tertiarySystemGroupedBackground
        case systemFill
        case secondarySystemFill
        case tertiarySystemFill
        case quaternarySystemFill

        public var colorAlternative: UIColor? { nil }
        public var uiColor: UIColor { rawValue }
        public var color: Color { Color(rawValue) }
        
        public init?(rawValue: UIColor) {
            if let some = Self.allCases.first(where: { $0.rawValue == rawValue }) {
                self = some
            } else {
                return nil
            }
        }
        
        public var rawValue: UIColor {
            switch self {
            case .black: return UIColor.black
            case .white: return UIColor.white
            case .gray: return UIColor.gray
            case .red: return UIColor.red
            case .green: return UIColor.green
            case .blue: return UIColor.blue
            case .orange: return UIColor.orange
            case .yellow: return UIColor.yellow
            case .lightGray: return UIColor.lightGray
            case .darkGray: return UIColor.darkGray

            case .systemIndigo: return UIColor.systemIndigo
            case .systemTeal: return UIColor.systemTeal
            case .systemPurple: return UIColor.systemPurple
            case .systemPink: return UIColor.systemPink
            case .systemYellow: return UIColor.systemYellow
            case .systemOrange: return UIColor.systemOrange
            case .systemRed: return UIColor.systemRed
            case .systemGreen: return UIColor.systemGreen
            case .systemBlue: return UIColor.systemBlue

            case .systemGray: return UIColor.systemGray
            case .systemGray2: return UIColor.systemGray2
            case .systemGray3: return UIColor.systemGray3
            case .systemGray4: return UIColor.systemGray4
            case .systemGray5: return UIColor.systemGray5
            case .systemGray6: return UIColor.systemGray6

            case .lightText: return UIColor.lightText
            case .darkText: return UIColor.darkText
            case .label: return UIColor.label
            case .secondaryLabel: return UIColor.secondaryLabel
            case .tertiaryLabel: return UIColor.tertiaryLabel
            case .quaternaryLabel: return UIColor.quaternaryLabel
            case .link: return UIColor.link
            case .placeholderText: return UIColor.placeholderText
            case .separator: return UIColor.separator
            case .opaqueSeparator: return UIColor.opaqueSeparator

            case .systemBackground: return UIColor.systemBackground
            case .secondarySystemBackground: return UIColor.secondarySystemBackground
            case .tertiarySystemBackground: return UIColor.tertiarySystemBackground
            case .systemGroupedBackground: return UIColor.systemGroupedBackground
            case .secondarySystemGroupedBackground: return UIColor.secondarySystemGroupedBackground
            case .tertiarySystemGroupedBackground: return UIColor.tertiarySystemGroupedBackground
            case .systemFill: return UIColor.systemFill
            case .secondarySystemFill: return UIColor.secondarySystemFill
            case .tertiarySystemFill: return UIColor.tertiarySystemFill
            case .quaternarySystemFill: return UIColor.quaternarySystemFill

            }
        }

        public var name: String {
            return "\(self)"
        }

    }
}

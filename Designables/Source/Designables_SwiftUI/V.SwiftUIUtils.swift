//
//  Created by Ricardo Santos on 02/03/2021.
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

public typealias SwiftUIUtils = App_Designables_SwiftUI.SwiftUIUtils

public extension App_Designables_SwiftUI {
    
    enum SwiftUIUtils {
        
        public struct VerticalDivider: View {
            public let width: CGFloat
            public init(width: CGFloat=1) {
                self.width = width
            }
            public var body: some View {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(width: width)
                        .background(ColorSemantic.backgroundPrimary.color)
                }
            }
        }
        
        public struct FixedVerticalSpacer: View {
            public let value: CGFloat
            public init(value: CGFloat) {
                self.value = value
            }
            public var body: some View {
                Rectangle()
                    .fill(Color.clear)
                    .background(Color.clear, alignment: .center)
                    .frame(width: 1, height: value)
            }
        }
        
        public struct FixedHorizontalSpacer: View {
            public let value: CGFloat
            public init(value: CGFloat) {
                self.value = value
            }
            public var body: some View {
                Rectangle()
                    .fill(Color.clear)
                    .background(Color.clear, alignment: .center)
                    .frame(width: value, height: 1)
            }
        }
    }
}

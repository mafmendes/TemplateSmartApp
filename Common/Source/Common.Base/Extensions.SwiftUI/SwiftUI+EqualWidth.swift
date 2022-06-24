//
//  Created by Santos, Ricardo Patricio dos  on 14/05/2021.
//

import SwiftUI
import UIKit
import Foundation

//
// https://developer.apple.com/documentation/swiftui/preferencekey
// https://augmentedcode.io/2020/05/10/setting-an-equal-width-to-text-views-in-swiftui/
//

public extension CommonNameSpace {
    struct EqualWidthPreferenceKey: PreferenceKey {
        public typealias Value = CGFloat
        public static var defaultValue: CGFloat = 0
        public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

public extension CommonNameSpace {
    struct EqualWidth: ViewModifier {
        let width: Binding<CGFloat?>
        public func body(content: Content) -> some View {
            content.frame(width: width.wrappedValue, alignment: .leading)
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: CommonNameSpace.EqualWidthPreferenceKey.self, value: proxy.size.width)
                }).onPreferenceChange(CommonNameSpace.EqualWidthPreferenceKey.self) { (value) in
                    self.width.wrappedValue = max(self.width.wrappedValue ?? 0, value)
                }
        }
    }
}

extension View {
    func equalWidth(_ width: Binding<CGFloat?>) -> some View {
        return modifier(CommonNameSpace.EqualWidth(width: width))
    }
}

//
// MARK: - Previews
//
#if canImport(SwiftUI) && DEBUG
struct Commom_Previews_EqualWidthModifier {
    
    struct ContentView: View {
        @State private var textMinWidth: CGFloat?
        var body: some View {
            VStack(spacing: 16) {
                TextBubble(text: "First", minTextWidth: $textMinWidth)
                TextBubble(text: "Second longer", minTextWidth: $textMinWidth)
            }
        }
    }

    struct TextBubble: View {
        let text: String
        let minTextWidth: Binding<CGFloat?>
        
        var body: some View {
            Text(text).equalWidth(minTextWidth) // custom view modifier
                .foregroundColor(Color.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
    }

    struct Preview: PreviewProvider {
        public static var previews: some View {
            ContentView()
        }
    }
}
#endif

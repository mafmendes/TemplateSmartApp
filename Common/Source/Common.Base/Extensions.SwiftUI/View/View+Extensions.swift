//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import SwiftUI

// swiftlint:disable logs_rule_1

//
// MARK: - Strokes
//

public extension SwiftUI.Shape {
    func strokeSimple(color: UIColor, width: CGFloat) -> some View {
        stroke(Color(color), lineWidth: width)
    }
}

public extension RoundedRectangle {
    func strokeDashed(color: UIColor, width: CGFloat, dashSize: CGFloat = 10) -> some View {
        strokeBorder(style: StrokeStyle(lineWidth: width, dash: [dashSize]))
            .foregroundColor(Color(color))
    }
}

//
// MARK: - View (Padding)
//

public extension View {
    
    // A view that pads this view using the specified edge insets with specified amount of padding.
    func paddingLeft(_ value: CGFloat) -> some View {
        padding(.leading, value)
    }
    func paddingRigth(_ value: CGFloat) -> some View {
        padding(.trailing, value)
    }
    func paddingBottom(_ value: CGFloat) -> some View {
        padding(.bottom, value)
    }
    func paddingTop(_ value: CGFloat) -> some View {
        padding(.top, value)
    }
}

//
// MARK: - View (Corner utils)
//

private struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public extension View {
    
    /// Usage `.cornerRadius(24, corners: [.topLeft, .topRight])`
    func cornerRadius1(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func cornerRadius2(_ radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
    
    func cornerRadius3(_ radius: CGFloat) -> some View {
        cornerRadius(radius)
    }
    
    func cornerRadius4(_ radius: CGFloat, _ color: Color) -> some View {
        cornerRadius(radius-1)  // Inner corner radius
        .padding(1)             // Width of the border
        .background(color)      // Color of the border
        .cornerRadius(radius)   // Outer corner radius
    }
}

public extension View {

    // https://medium.com/better-programming/swiftui-tips-and-tricks-c7840d8eb01b
    var embedInNavigation: some View {
        NavigationView { self }
    }

    var erased: AnyView {
        AnyView(self)
    }

    var erasedToAnyView: AnyView {
        AnyView(self)
    }

    @inlinable func userInteractionEnabled(_ value: Bool) -> some View {
        disabled(!value)
    }

    @inlinable func rotate(degrees: Double) -> some View {
        rotationEffect(.degrees(degrees))
    }

    @inlinable func alpha(_ some: Double) -> some View {
        opacity(some)
    }

    @inlinable func addCorner(color: Color, lineWidth: CGFloat, padding: Bool) -> some View {
        doIf(padding) { $0.padding(8) }
            .overlay(Capsule(style: .continuous).stroke(color, lineWidth: lineWidth).foregroundColor(Color.clear))
    }
}

public extension View {
    
    /// Usage `Circle().maskContent(using: AngularGradient(gradient: colors, center: .center, startAngle: .degrees(0), endAngle: .degrees(360)))`
    func maskContent<T: View>(using: T) -> some View {
        using.mask(self)
    }
}

public extension Common_Preview {
    struct ConditionalViews: View {
        // @State is view’s internal state, owned by the view and should only be updated by it.
        // For information only UI relevant, not persisted and has no impact on the logic of the app
        @State private var condition = false
        public init() { }
        public var body: some View {
            VStack {
                Button("Tap me") { condition.toggle() }
                Spacer()
                VStack {
                    Text("if")
                    ImageSFSymbol.heart.image
                        .doIf(condition) { some in some.rotate(degrees: 90) }
                    ImageSFSymbol.heart.image
                        .doIf(condition, transform: { $0.rotate(degrees: -90) })
                }
                VStack {
                    Text("ifOnSimulator")
                    ImageSFSymbol.star.image
                        .ifOnSimulator { some in some.foregroundColor(Color(.systemPink)) }
                    ImageSFSymbol.star.image
                        .ifOnSimulator { $0.foregroundColor(Color(.systemPink)) }
                }
                VStack {
                    Text("ifCondition")
                    ImageSFSymbol.star.image
                        .ifCondition(condition) { some in some.foregroundColor(Color(.systemPink)) }
                    ImageSFSymbol.star.image
                        .ifCondition(condition) { $0.foregroundColor(Color(.systemPink)) }
                }
                VStack {
                    Text("ifElseCondition")
                    ImageSFSymbol.circle.image
                        .ifElseCondition(condition) { some in some.foregroundColor(Color(.blue)) } else: { some in some.foregroundColor(Color(.green)) }
                    ImageSFSymbol.circle.image
                        .ifElseCondition(condition) { $0.foregroundColor(Color(.blue)) } else: { $0.foregroundColor(Color(.green)) }
                }
                VStack {
                    performAndReturnEmptyIfSimulator { Common_Logs.debug("On Simulator") }
                    performAndReturnEmpty { Common_Logs.debug("perfomed_1") }
                    performAndReturnEmpty(if: condition) {
                        Common_Logs.debug("perfomed_2")
                    }
                }
                Spacer()
            }
        }
    }
}

#if canImport(SwiftUI) && DEBUG
private struct PViewWithAnyViewsPreviews: PreviewProvider {
    public static var previews: some View {
        Common_Preview.ConditionalViews()
    }
}
#endif

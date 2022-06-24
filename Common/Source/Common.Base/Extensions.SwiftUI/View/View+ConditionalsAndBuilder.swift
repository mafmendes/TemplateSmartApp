//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import SwiftUI

//
// MARK: - Conditionals and Builder
// https://medium.com/better-programming/swiftui-tips-and-tricks-c7840d8eb01b
// https://matteo-puccinelli.medium.com/conditionally-apply-modifiers-in-swiftui-51c1cf7f61d1
//

public extension View {
    
    func performAndReturnSelf(_ block: () -> Void) -> some View {
        block()
        return self
    }
    
    func performAndReturnEmpty(_ block: () -> Void) -> some View {
        block()
        return EmptyView()
    }

    func performAndReturnEmpty(if condition: Bool, _ block: () -> Void) -> some View {
        if condition {
            block()
        }
        return EmptyView()
    }

    func performAndReturnEmptyIfSimulator(_ block: () -> Void) -> some View {
        return performAndReturnEmpty(if: Common_Utils.onSimulator, block)
    }

    // IfOnSimulator(view: Text("\(Date()) - Reloaded").eraseToAnyView())
    func ifOnSimulator<TrueContent: View>(then transform: (Self) -> TrueContent) -> some View {
        Common_Utils.onSimulator ? transform(self).erasedToAnyView : self.erasedToAnyView
    }

    // @ViewBuilder: A custom parameter attribute that constructs views from closures.
    @ViewBuilder
    func ifElseCondition<TrueContent: View, FalseContent: View>(_ condition: @autoclosure () -> Bool,
                                                                then trueContent: (Self) -> TrueContent,
                                                                else falseContent: (Self) -> FalseContent) -> some View {
        if condition() { trueContent(self)
        } else { falseContent(self) }
    }

    // @ViewBuilder: A custom parameter attribute that constructs views from closures.
    @ViewBuilder
    func ifCondition<TrueContent: View>(_ condition: Bool,
                                        then trueContent: (Self) -> TrueContent) -> some View {
        self.ifElseCondition(condition, then: trueContent, else: { _ in self })
    }

    func doIf<Content: View>(_ condition: @autoclosure () -> Bool,
                             transform: (Self) -> Content) -> some View {
        // Booth versions bellow work
        let method = Int.random(in: 0...3)
        if method == 1 {
            return Group { if condition() { transform(self) } else { self } }.erased
        } else if method == 2 {
            return condition() ? transform(self).erased : erased
        } else {
            return ifCondition(condition(), then: transform).erased
        }
    }
    
    @ViewBuilder
    func onChangeBackwardsCompatible<T: Equatable>(of value: T, perform completion: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: completion)
        } else {
            self.onReceive([value].publisher.first()) { (value) in
                completion(value)
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

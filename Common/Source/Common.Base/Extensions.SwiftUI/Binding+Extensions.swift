//
//  Created by Santos, Ricardo Patricio dos  on 20/04/2021.
//

import Foundation
import Combine
import SwiftUI

// @Binding property: a two-way connection to a state owned by someone else.
// Can be updated by both and changes to it will trigger updates on both views.

public extension Binding {
    
    /**
        __Usage__
     ```
     struct ToggleWithStateV1: View {
         @State var isOn: Bool = false
         public var body : some View {
             Toggle("Hi", isOn: $isOn.didSet { (state) in
                 DevTools.Log.debug(state, .generic)
             })
         }
     }
     ```
     */
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}

public extension Binding {
    /**
     ```
    struct DeveloperScreen: View {
        @State var batteryValue: Double = 0
        var body : some View { Slider(value: $batteryValue.onChange(batteryValueChanged), in: 0...100, step: 1) }
        func batteryValueChanged(to value: Double) { DevTools.Log.message("Changed to \(value)!") }
     }
     ```
     */
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

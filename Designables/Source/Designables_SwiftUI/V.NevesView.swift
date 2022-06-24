//
//  Created by Santos, Ricardo Patricio dos  on 14/05/2021.
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

public typealias NevesView = App_Designables_SwiftUI.NevesView

//
// MARK: - Designable ViewModel
//

public extension VM {
    
    enum NevesView {
            
        //
        // Sizes
        //
        
        enum Sizes {

        }
        
        //
        // Constants
        //
        
        enum Constants {
            static var spacerH: CGFloat = SizeNames.size_8.cgFloat
        }
        
        //
        // ViewOutput
        //
        
        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            public enum Action: Hashable {
                case btnPressed(date: Date, userName: String, password: String)
            }
        }
        
        //
        // ViewInput
        //
        
        // Objects marked as @ObservedObject need to implement ObservableObject protocol and have
        // properties defined with the @Published property wrapper, indicating which properties
        // trigger observation notifications when changed.
                
        public class ViewInput: ObservableObject, Hashable {
            
            public static func == (lhs: ViewInput, rhs: ViewInput) -> Bool {
                lhs.userName == rhs.userName && lhs.password == rhs.password
            }
            public func hash(into hasher: inout Hasher) {
                hasher.combine(userName)
                hasher.combine(password)
            }
            
            // Simple title and single value
            public init(userName: String = "",
                        password: String = "",
                        message: String = "") {
                self.userName = userName
                self.password = password
                self.message = message
            }
                        
            @Published public var userName: String = ""
            @Published public var password: String = ""
            @Published public var message: String = ""
            @Published public var messageStyle: TextStyleTuple = (font: .footnote, color: .labelSecondary, options: nil)

            var titleStyle: TextStyleTuple = (font: .body, color: .labelPrimary, options: nil)
            var valueStyle: TextStyleTuple = (font: .footnote, color: .labelSecondary, options: nil)
        }
    }
}

//
// MARK: - Designable View
//

public extension App_Designables_SwiftUI {
    struct NevesView: View {
        
        // Mandatory for all View(s) : [@ObservedObject var input], [public var output] and [var colorScheme]
        @ObservedObject public var input: VM.NevesView.ViewInput
        public var output = GenericObservableObjectForHashable<VM.NevesView.ViewOutput.Action>()
        @Environment(\.colorScheme) var colorScheme
        
        public init(input: VM.NevesView.ViewInput) {
            self.input = input
        }

        public var body: some View {
            VStack(spacing: 0) {
                SwiftUIUtils.FixedVerticalSpacer(value: SizeNames.defaultMargin)
                HStack(spacing: 0) {
                    Text("UserName" ).applyStyle(input.titleStyle)
                    Spacer()
                    TextField("Username", text: $input.userName).applyStyle(input.valueStyle)
                }
                HStack(spacing: SizeNames.size_2.cgFloat) {
                    Text("Password").applyStyle(input.titleStyle)
                    Spacer()
                    TextField("Password", text: $input.password).applyStyle(input.valueStyle)
                }
                SwiftUIUtils.FixedVerticalSpacer(value: SizeNames.defaultMargin)
                Text(input.message).applyStyle(input.messageStyle)
                SwiftUIUtils.FixedVerticalSpacer(value: SizeNames.defaultMargin)
                Button("Login") {
                    output.value.send(.btnPressed(date: Date(), userName: input.userName, password: input.password))
                }
                SwiftUIUtils.FixedVerticalSpacer(value: SizeNames.defaultMargin)
            }.padding()
        }
    }
}

//
// MARK: - Previews
//
#if canImport(SwiftUI) && DEBUG
struct Designables_Previews_NevesView {
    
    static let input = VM.NevesView.ViewInput(userName: "userName", password: "password")
    
    struct Preview: PreviewProvider {
        public static var previews: some View {
            VStack {
                App_Designables_SwiftUI.NevesView(input: input)
                Spacer()
            }.padding()
        }
    }
}
#endif

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

public typealias TableItemWithGenericAccessory = App_Designables_SwiftUI.TableItemWithGenericAccessory

//
// MARK: - Designable ViewModel
//

public extension VM {
    
    enum TableItemWithGenericAccessory {
        
        //
        // Sizes
        //
        
        enum Sizes {
            
        }
        
        //
        // Constants
        //
        
        public enum Constants {
            public static var innerVerticalMargin: CGFloat { SizeNames.size_2.cgFloat }
            public static var verticalMarginTopAndBottom: CGFloat { innerVerticalMargin * 3 }
        }
        
        //
        // Mappers
        //
        
        enum Mappers {
            /// Naming convension mapping `AAA` into `BBB` : `func mapToBBB(aaa model: AAA) -> BBB`
        }
        
        //
        // ViewOutput
        //
        
        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            public enum Action: Hashable {
                case acessoryTapped(acessoryIdentifier: AccessibilityIdentifier)
                case rowTapped(acessoryIdentifier: AccessibilityIdentifier)
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
                lhs.title == rhs.title && lhs.value == rhs.value && lhs.acessoryIdentifier == rhs.acessoryIdentifier && lhs.titleLineLimit == rhs.titleLineLimit
            }
            public func hash(into hasher: inout Hasher) {
                hasher.combine(title)
                hasher.combine(value)
                hasher.combine(acessoryIdentifier)
                hasher.combine(titleLineLimit)
            }
            
            // Simple title and single value
            public init(title: String,
                        value: String,
                        acessoryIdentifier: AccessibilityIdentifier = .na,
                        titleLineLimit: Int = 1) {
                self.title = title
                self.value = value
                self.acessoryIdentifier = acessoryIdentifier
                self.titleLineLimit = titleLineLimit
            }
            
            @Published public var title: String = ""
            @Published public var value: String = ""
            @Published public var titleStyle: TextStyleTuple = (font: .bodyBold,
                                                                color: .labelPrimary,
                                                                options: nil)
            @Published public var titleLineLimit: Int = 1
            @Published public var valueStyle: TextStyleTuple = (font: .footnote,
                                                                color: .labelSecondary, 
                                                                options: nil)
            @Published public var acessoryIdentifier: AccessibilityIdentifier = .na
            //
            // Sugar
            //
            public func setValue(_ value: String) { self.title = value }
            public func setTitle(_ value: String) { self.value = value }
        }
    }
}

public extension App_Designables_SwiftUI.TableItemWithGenericAccessory {
    func setTitle(_ value: String) { input.title = value }
    func setValue(_ value: String) { input.value = value }
}

extension App_Designables_SwiftUI.TableItemWithGenericAccessory: Equatable {
    public static func == (lhs: TableItemWithGenericAccessory<Accessory>,
                           rhs: TableItemWithGenericAccessory<Accessory>) -> Bool {
        lhs.input.hashValue == rhs.input.hashValue &&
        lhs.id == rhs.id
    }
}

//
// MARK: - Designable View
//

public extension App_Designables_SwiftUI {
    struct TableItemWithGenericAccessory<Accessory: View>: View, Identifiable {
        
        // Mandatory for all View(s) : [@ObservedObject var input], [public var output] and [var colorScheme]
        @ObservedObject var input: VM.TableItemWithGenericAccessory.ViewInput
        public var output = GenericObservableObjectForHashable<VM.TableItemWithGenericAccessory.ViewOutput.Action>()
        @Environment(\.colorScheme) var colorScheme
        private var accessoryView: Accessory
        private var onAcessoryTap: () -> Void = { }
        private var onRowTap: () -> Void = { }
        public let id: String
        public init(input: VM.TableItemWithGenericAccessory.ViewInput,
                    accessoryView: Accessory,
                    accessoryViewHashValue: String, // Must be unique!
                    onAcessoryTap: @escaping () -> Void,
                    onRowTap: @escaping () -> Void) {
            self.input = input
            self.accessoryView = accessoryView
            self.onAcessoryTap = onAcessoryTap
            self.onRowTap = onRowTap
            self.id = "\(input.hashValue)_\(accessoryViewHashValue)"
        }
        
        private var innerVerticalMargin: CGFloat {
            VM.TableItemWithGenericAccessory.Constants.innerVerticalMargin
        }
        
        private var verticalMarginTopAndBottom: CGFloat {
            VM.TableItemWithGenericAccessory.Constants.verticalMarginTopAndBottom
        }
        
        public var body: some View {
            let haveSubTitle = input.value.trim.count > 0
            return HStack(alignment: .top, content: {
                VStack(alignment: .leading, spacing: 0) {
                    Group {
                        if haveSubTitle {
                            SwiftUIUtils.FixedVerticalSpacer(value: verticalMarginTopAndBottom)
                            Text(input.title)
                                .applyStyle(input.titleStyle)
                                .frame(maxWidth: .infinity, alignment: .trailing) 
                                .lineLimit(input.titleLineLimit)
                                .fixedSize(horizontal: false, vertical: true) // Forces new line instead of truncate
                            SwiftUIUtils.FixedVerticalSpacer(value: innerVerticalMargin)
                            Text(input.value)
                                .applyStyle(input.valueStyle)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true) // Forces new line instead of truncate
                            SwiftUIUtils.FixedVerticalSpacer(value: verticalMarginTopAndBottom)
                        } else {
                            Spacer()
                            Text(input.title)
                                .applyStyle(input.titleStyle)
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true) // Forces new line instead of truncate
                            Spacer()
                        }
                    }
                }
                Spacer(minLength: 0)
                // #SAE-742
                SwiftUIUtils.FixedHorizontalSpacer(value: verticalMarginTopAndBottom)
                // #SAE-742
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    accessory
                    Spacer()
                }
            })
            .onTapGesture(count: 1) {
                onRowTap()
                output.value.send(.rowTapped(acessoryIdentifier: input.acessoryIdentifier))
            }.erased
        }
        
        @ViewBuilder
        public var accessory: some View {
            // WARNING : If `accessoryView` is a `Button`, the origin Button must implement tap
            // because `accessoryView.onTapGesture` wont be called
            accessoryView
                .onTapGesture(count: 1) {
                    onAcessoryTap()
                    output.value.send(.acessoryTapped(acessoryIdentifier: input.acessoryIdentifier))
                }.erased
        }
    }
}

//
// MARK: - Previews
//
#if canImport(SwiftUI) && DEBUG
public struct Designables_Previews_TableItemWithGenericAccessory {
    public struct Preview: PreviewProvider {
        
        public static var accessoryButton: some View {
            Button("Tap me") {
                // p rint("on Button tap A")
            }
        }
        
        public static var accessoryImage: some View {
            ImageName.plus.image
        }
        public static var previews: some View {
            VStack {
                App_Designables_SwiftUI.TableItemWithGenericAccessory(input: .init(title: "title 1", value: "value 1"),
                                                                      accessoryView: accessoryButton.erased,
                                                                      accessoryViewHashValue: "1",
                                                                      onAcessoryTap: {
                    
                }, onRowTap: {})
                Spacer()
            }.padding()
        }
    }
}
#endif

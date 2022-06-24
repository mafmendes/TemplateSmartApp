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

public typealias GenericListForItemWithGenericAccessory = App_Designables_SwiftUI.GenericListForItemWithGenericAccessory

//
// MARK: - Designable ViewModel
//

public extension VM {
    
    enum GenericListForItemWithGenericAccessory {
            
        //
        // Sizes
        //
        
        enum Sizes {

        }
        
        //
        // Constants
        //
        
        enum Constants {
            static var spacerH: CGFloat = 50
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
                case na
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
                lhs.title == rhs.title
            }
            public func hash(into hasher: inout Hasher) {
                hasher.combine(title)
            }
            
            // Simple title and array of values
            public init(title: String?,
                        values: [App_Designables_SwiftUI.TableItemWithGenericAccessory<AnyView>],
                        titlePaddingBottom: CGFloat = 0,
                        horizontalPadding: CGFloat = SizeNames.defaultMargin,
                        viewBackground: ColorSemantic = .backgroundSecondary
            ) {
                self.title = title
                self.items = values
                self.titlePaddingBottom = titlePaddingBottom
                self.horizontalPadding = horizontalPadding
                self.background = viewBackground
                
            }
             
            @Published public var title: String?
            @Published public var items: [App_Designables_SwiftUI.TableItemWithGenericAccessory<AnyView>] = []
            @Published public var titlePaddingBottom: CGFloat = 0
            @Published public var titleStyle: TextStyleTuple = (font: .headline, color: .labelPrimary, options: nil)
            @Published public var background: ColorSemantic = .backgroundSecondary
            @Published public var horizontalPadding: CGFloat = SizeNames.defaultMargin
        }
    }
}

//
// MARK: - Designable View
//

public extension App_Designables_SwiftUI {
    struct GenericListForItemWithGenericAccessory: View {
        
        // Mandatory for all View(s) : [@ObservedObject var input], [public var output] and [var colorScheme]
        @ObservedObject public var input: VM.GenericListForItemWithGenericAccessory.ViewInput
        public var output = GenericObservableObjectForHashable<VM.GenericListForItemWithGenericAccessory.ViewOutput.Action>()
        @Environment(\.colorScheme) var colorScheme
        
        public init(input: VM.GenericListForItemWithGenericAccessory.ViewInput) {
            self.input = input
        }

        public var body: some View {
            let isSingleItemElement = input.items.count == 1
            let haveTitle = input.title?.trim.count ?? 0 > 0
            
            let verticalSeparator =
                Group {
                    if haveTitle {
                        SwiftUIUtils.FixedVerticalSpacer(value: VM.TableItemWithGenericAccessory.Constants.verticalMarginTopAndBottom)
                    } else {
                        EmptyView()
                    }
                }
                
            let justListview =
                VStack(alignment: .leading, spacing: 0) {
                    verticalSeparator
                    ForEach(input.items) { item in
                        item.erased
                        .paddingLeft(SizeNames.defaultMargin)
                        .paddingRigth(SizeNames.defaultMargin)
                        if item != input.items.last && !isSingleItemElement {
                            // Only if we have more that 1 item
                            Divider()
                        }
                    }
                    verticalSeparator
                }
                .background(ColorSemantic.backgroundPrimary.color)
                .cornerRadius2(SizeNames.defaultMargin)
                
            let titleAndListView =
                VStack(alignment: .leading, spacing: 0) {
                    if let title = input.title {
                        Text(title)
                            .applyStyle(input.titleStyle)
                            .padding(.bottom, input.titlePaddingBottom)
                    }
                    justListview
                }
            
            let result =
                Group {
                    if haveTitle {
                        titleAndListView
                    } else {
                        justListview
                    }
                }
            
            return result
                .paddingRigth(input.horizontalPadding)
                .paddingLeft(input.horizontalPadding)
                .background(input.background.color)
                .doIf(isSingleItemElement, transform: {
                    // List with single item, have fixed height
                    $0.frame(height: SizeNames.size_11.cgFloat)
                })
        }
    }
}

//
// MARK: - Previews
//
#if canImport(SwiftUI) && DEBUG
struct Designables_Previews_GenericListForItemWithGenericAccessory {
        
    public static var accessoryButton: some View {
        Button("Tap me") {

        }
    }
    
    public static var accessoryImage: some View {
        ImageName.plus.image
    }
    
    static let itemA = App_Designables_SwiftUI.TableItemWithGenericAccessory(input: .init(title: "title 1", value: "value 1"),
                                                                             accessoryView: accessoryButton.erased,
                                                                             accessoryViewHashValue: "1",
                                                                             onAcessoryTap: {
        //  p rint("tapped 1")
    }, onRowTap: {})
    
    static let itemB = App_Designables_SwiftUI.TableItemWithGenericAccessory(input: .init(title: "title 2", value: "value 2"),
                                                                             accessoryView: accessoryImage.erased,
                                                                             accessoryViewHashValue: "2",
                                                                             onAcessoryTap: {
        //    p rint("tapped 2")
    }, onRowTap: {})
    
    struct Preview: PreviewProvider {
        public static var previews: some View {
            ScrollView {
                App_Designables_SwiftUI.GenericListForItemWithGenericAccessory(input: .init(title: "Modes", values: [itemA, itemB]))
            }
        }
    }
}
#endif

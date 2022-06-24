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
import Designables
import BaseDomain

//
// MARK: - Designable ViewModel
//

public extension VM {
    
    enum ZipCodesListHolder {
            
        public struct TableItem: ModelProtocol, Equatable, Identifiable {
            public let title, value, id: String
            
            public init(title: String, value: String, id: String) {
                self.title = title
                self.value = value
                self.id = id
            }
            
            enum CodingKeys: String, CodingKey {
                case title, value, id
            }
        }
        
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
                //case btnPressed(date: Date, userName: String, password: String)
                case itemPressed(id: String)
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
                lhs.items == rhs.items && lhs.title == rhs.title
            }
            public func hash(into hasher: inout Hasher) {
                hasher.combine(items)
                hasher.combine(title)
            }
            
            public init(title: String, items: [VM.ZipCodesListHolder.TableItem]) {
                self.items = items
                self.title = title
            }
                     
            @Published public var title: String = ""
            @Published public var items: [VM.ZipCodesListHolder.TableItem] = []
        }
    }
}

//
// MARK: - Designable View
//

public extension V {
    struct ZipCodesListHolder: View {
        
        // Mandatory for all View(s) : [@ObservedObject var input], [public var output] and [var colorScheme]
        @ObservedObject public var input: VM.ZipCodesListHolder.ViewInput
        public var output = GenericObservableObjectForHashable<VM.ZipCodesListHolder.ViewOutput.Action>()
        @Environment(\.colorScheme) var colorScheme
        
        public init(input: VM.ZipCodesListHolder.ViewInput) {
            self.input = input
        }

        public var body: some View {
            Group {
                if input.items.count == 0 {
                    bodyEmpty
                } else {
                    bodyWithData
                }
            }
        }
        
        private var bodyEmpty: some View {
            Text("No data...").alpha(0.5)
        }
        
        private var bodyWithData: some View {
            ScrollView {
                let values: [App_Designables_SwiftUI.TableItemWithGenericAccessory<AnyView>] = input.items.map({
                    let id = $0.id
                    return App_Designables_SwiftUI.TableItemWithGenericAccessory.init(input: .init(title: $0.title, value: $0.value),
                                                                               accessoryView: EmptyView().erased,
                                                                               accessoryViewHashValue: $0.id,
                                                                               onAcessoryTap: {
                    }, onRowTap: {
                        output.value.send(.itemPressed(id: id))
                    })
                })
                App_Designables_SwiftUI.GenericListForItemWithGenericAccessory(input: .init(title: input.title, values: values))
            }
        }
    }
}

//
// MARK: - Previews
//
#if canImport(SwiftUI) && DEBUG
struct ZipCodesListHolder_Preview {
    
    static let input = VM.ZipCodesListHolder.ViewInput(title: "title", items: [.init(title: "title", value: "value", id: "id")])
    
    struct Preview: PreviewProvider {
        public static var previews: some View {
            VStack {
                V.ZipCodesListHolder(input: input)
                Spacer()
            }.padding()
        }
    }
}
#endif

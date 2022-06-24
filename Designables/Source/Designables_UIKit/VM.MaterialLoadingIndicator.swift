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

//
// MARK: ViewModel
//

public extension VM {
    
    enum MaterialLoadingIndicator {
        
        //
        // Sizes
        //
        
        enum Sizes {
            
        }
        
        //
        // Constants
        //
        
        enum Constants {
            
        }
                
        //
        // ViewOutput
        //
        
        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            public enum Action: Hashable {
                
            }
        }
        
        //
        // ViewInput
        //
        
        // Objects marked as @ObservedObject need to implement ObservableObject protocol and have
        // properties defined with the @Published property wrapper, indicating which properties
        // trigger observation notifications when changed.
        public class ViewInput: ObservableObject, Hashable {
            
            public static func == (lhs: ViewInput, rhs: ViewInput) -> Bool { lhs.radius == rhs.radius }
            public func hash(into hasher: inout Hasher) { hasher.combine(radius) }
            
            public init() {
                self.isLoading = false
                self.radius = 0
            }
            
            public init(isLoading: Bool,
                        radius: CGFloat,
                        lineWidth: (CGFloat, CGFloat)? = nil) {
                self.isLoading = isLoading
                self.radius = radius
                self.lineWidth = lineWidth
            }
            
            @Published public var isLoading: Bool = true
            @Published public var radius: CGFloat = 10
            @Published public var lineWidth: (CGFloat, CGFloat)?
        }
    }
}

//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
import Combine
import SwiftUI
//
import Common
import BaseUI
import BaseDomain
import DevTools
import Resources
import Designables
import AppConstants
import AppDomain

public extension VM {
    enum ToolBar {

        //
        // Sizes
        //
        
        enum Sizes {
            
            public static var distanceFromBottom: CGFloat {
                if VM.ToolBar.Constants.isFloatingToolBar {
                    return SizeNames.size_8.cgFloat
                } else {
                    return 0
                }
            }
            
            public static var frameToolBar: CGRect {
                CGRect(x: (screenWidth - VM.ToolBar.Sizes.defaultSize.width)/2,
                                   y: screenHeight - VM.ToolBar.Sizes.defaultSize.height - distanceFromBottom,
                                   width: VM.ToolBar.Sizes.defaultSize.width,
                                   height: VM.ToolBar.Sizes.defaultSize.height)
            }
            
            public static var frameView: CGRect {
                CGRect(x: 0,
                       y: 0,
                       width: VM.ToolBar.Sizes.defaultSize.width,
                       height: VM.ToolBar.Sizes.defaultSize.height)
            }
            
            /// Toolbar expected size
            public static var defaultSize: CGSize {
                if VM.ToolBar.Constants.isFloatingToolBar {
                    return CGSize(width: SizeNames.size_37.cgFloat, height: SizeNames.size_9.cgFloat )
                } else {
                    var height: CGFloat = SizeNames.size_9.cgFloat
                    let window = UIApplication.shared.windows[0]
                    let bottomPadding = window.safeAreaInsets.bottom
                    height += bottomPadding
                    return CGSize(width: screenWidth, height: height)
                }
            }

            /// Toolbar buttons expected size
            public static var defaultSizeButton: CGSize {
                CGSize(width: SizeNames.size_8.cgFloat, height: SizeNames.size_8.cgFloat)
            }
            
            /// Toolbar images expected size
            public static var defaultSizeImage: CGSize {
                CGSize(width: defaultSizeButton.width * 0.55, height: defaultSizeButton.height * 0.55)
            }
            
            public static var defaultSizeImageContainer: CGSize {
                CGSize(width: defaultSizeButton.width, height: defaultSizeButton.height)
            }
            
        }
        
        //
        // Constants
        //
                
        enum Constants {
            static var isFloatingToolBar: Bool {
                return false
            }
            static var cornerRadius: CGFloat {
                if isFloatingToolBar {
                    return VM.ToolBar.Sizes.defaultSize.height / 2
                } else {
                    return 0
                }
            }
        }
        
        //
        // ViewOutput
        //
        
        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            public enum Action: Hashable {
                case taped(index: Int, id: AccessibilityIdentifier, state: SmartState?)
            }
        }
        
        // Objects marked as @ObservedObject need to implement ObservableObject protocol and have
        // properties defined with the @Published property wrapper, indicating which properties
        // trigger observation notifications when changed.
        public class ViewInput: ObservableObject, Hashable {
            public static func == (lhs: ViewInput, rhs: ViewInput) -> Bool { lhs.param == rhs.param }
            public func hash(into hasher: inout Hasher) { hasher.combine(param) }
            
            public init(param: Bool = true) {
                self.param = param
            }
            @Published public var param: Bool = false
        }
    }
}

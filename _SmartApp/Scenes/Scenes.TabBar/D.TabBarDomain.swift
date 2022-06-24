//
//  D.TabBarDomain.swift
//  SmartApp
//
//  Created by Santos, Ricardo Patricio dos  on 26/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
//
import BaseDomain
import AppDomain
import BaseUI

//
// MARK: - Protocols
//

protocol TabBarCoordinatorProtocol {
    func perform(_ action: C.TabBarCoordinator.Action)
    var viewController: VC.TabBarController? { get }
}

protocol TabBarViewProtocol {

}

protocol TabBarViewControllerProtocol {
    func display(tab: C.TabBarCoordinator.Action)
}

protocol TabBarViewModelProtocol {

}

//
// MARK: - Models
//

public extension VM {

    //
    // Naming convention: Given a Scene named D.TabBarDomain -> D.TabBarDomain
    //

    enum TabBar {

        //
        // Auxiliar ViewModels related/used on this view
        //
        
        public typealias ViewModelX = Model.Login

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
        // ViewModelInput: ViewController -> ViewModel
        //

        enum ViewModelInput {

            struct InitialSetup: Hashable {
                let name: String
            }

            // Rule : naming convention: Action, allways
            enum Action: Hashable {
                // Action naming rules:
                // 1 : [viewLoaded] and [softReLoad] Actions are mandatory.
                // 2 : Actions that are just "gets" of information, should start with "get" or end with "Refresh"
                // 3 : Actions who lead to screen change, shoud start with "route"

                // Mandatory Actions
                case viewLoaded // Get screen initial state (allways updating most recent data)
                case softReLoad // Use to put the screen/view on his initial state (without reloading)

            }
        }

        //
        // ViewOutput: View -> ViewController
        //

        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            public enum Action: Hashable {
              //  case dummy
            }
        }

        //
        // ViewInput: ViewModel -> ViewController/View
        //

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

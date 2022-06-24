//
//  D.ZipCodesListDomain.swift
//  SmartApp
//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseDomain
import AppDomain
import BaseUI

//
// D.ZipCodesListDomain files are used for:
//  - Declare Models (value types)
//  - Declare the View Protocol       -> ZipCodesListViewProtocol
//  - Declate ViewController Protocol -> ZipCodesListViewControllerProtocol
//  - Declate ViewModel Protocol      -> ZipCodesListViewModelProtocol
//  - Declate Coordenator Protocol    -> ZipCodesListCoordinatorProtocol
//

//
// MARK: - Protocols
//

protocol ZipCodesListCoordinatorProtocol {
    func perform(_ action: C.ZipCodesListCoordinator.Action)
    var viewController: UIViewController? { get }
    var childViewControllers: [UIViewController] { get }
    var viewControllerProtocol: ZipCodesListViewControllerProtocol? { get }
}

protocol ZipCodesListViewProtocol {

}

protocol ZipCodesListViewControllerProtocol {

}

protocol ZipCodesListViewModelProtocol {

}

//
// MARK: - Models
//

public extension VM {

    //
    // Naming convention: Given a Scene named D.ZipCodesListDomain -> D.ZipCodesListDomain
    //

    enum ZipCodesList {

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
                
                case fetchRecords(filter: String, delay: Bool, displayLoading: Bool)

            }
        }

        //
        // ViewOutput: View -> ViewController
        //

        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            public enum Action: Hashable {
                case search(value: String)
            }
        }

        //
        // ViewInput: ViewModel -> ViewController/View
        //

        public enum ViewInput {
  
            /// __ViewInput.ViewData__: Information sent from ViewModel to View. Should allways be _Hashable_ and _Enum_
            public enum ViewData: Hashable {
                case display(title: String, items: [VM.ZipCodesListHolder.TableItem])
            }
        }
    }
}

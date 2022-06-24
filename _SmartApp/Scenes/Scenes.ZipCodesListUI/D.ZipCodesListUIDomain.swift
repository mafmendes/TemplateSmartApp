//
//  D.ZipCodesListUIDomain.swift
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
// D.ZipCodesListUIDomain files are used for:
//  - Declare Models (value types)
//  - Declare the View Protocol       -> ZipCodesListUIViewProtocol
//  - Declate ViewController Protocol -> ZipCodesListUIViewControllerProtocol
//  - Declate ViewModel Protocol      -> ZipCodesListUIViewModelProtocol
//  - Declate Coordenator Protocol    -> ZipCodesListUICoordinatorProtocol
//

//
// MARK: - Protocols
//

protocol ZipCodesListUICoordinatorProtocol {
    func perform(_ action: C.ZipCodesListUICoordinator.Action)
    var viewController: UIViewController? { get }
    var childViewControllers: [UIViewController] { get }
    var viewControllerProtocol: ZipCodesListUIViewControllerProtocol? { get }
}

protocol ZipCodesListUIViewProtocol {

}

protocol ZipCodesListUIViewControllerProtocol {

}

protocol ZipCodesListUIViewModelProtocol {

}

//
// MARK: - Models
//

public extension VM {

    //
    // Naming convention: Given a Scene named D.ZipCodesListUIDomain -> D.ZipCodesListUIDomain
    //

    enum ZipCodesListUI {

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
            static var tableIdentifier = "Cell"
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
                case display(title: String)
                
                case routeToNewScreen(title: String, imageLight: UIImage, imageDark: UIImage, postalcode: String)
               
            }
        }

        //
        // ViewOutput: View -> ViewController
        //

        // struct naming convention: ViewOutput, allways, Hashable allways
        public enum ViewOutput {
            public enum Action: Hashable {
                case search(value: String)
                case cellSelected(cell: VM.ZipCodesListUIHolder.TableItem)
                case routeToNewScreen(city: String, imageDark: UIImage, imageLight: UIImage, postalcode: String)
            }
        }

        //
        // ViewInput: ViewModel -> ViewController/View
        //

        public enum ViewInput {
  
            /// __ViewInput.ViewData__: Information sent from ViewModel to View. Should allways be _Hashable_ and _Enum_
            public enum ViewData: Hashable {
                case display(title: String, items: [VM.ZipCodesListUIHolder.TableItem])
                case displayAlert(title: String, type: AlertType)
            }
        }
    }
}

//
//  D.TitleDomain.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 14/04/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseDomain
import AppDomain
import BaseUI
import AppConstants

#warning("Tutorial: D._xxx_Domain files ->")

//
// D.TitleDomain files are used for:
//  - Declare Models (value types)
//  - Declare the View Protocol       -> TitleViewProtocol
//  - Declate ViewController Protocol -> TitleViewControllerProtocol
//  - Declate ViewModel Protocol      -> TitleViewModelProtocol
//  - Declate Coordinator Protocol    -> TitleCoordinatorProtocol
//

//
// MARK: - Protocols
//

/// The Scene Coordinator Protocol
protocol TitleCoordinatorProtocol {
    func perform(_ action: C.TitleCoordinator.Action)
    var viewController: UIViewController? { get }
    var childViewControllers: [UIViewController] { get }
    var viewControllerProtocol: TitleViewControllerProtocol? { get }
}

/// The View ViewController Protocol
protocol TitleViewProtocol {
    func viewWillAppear()
    func viewWillFirstAppear()
    func viewDidAppear()
}

/// The Scene ViewController Protocol
protocol TitleViewControllerProtocol {

}

/// The Scene ViewModel Protocol
protocol TitleViewModelProtocol {

}

//
// MARK: - Models
//

public extension VM {

    //
    // Naming convention: Given a Scene named D.TitleDomain -> D.TitleDomain
    //

    enum Title {

        //
        // Sizes
        //
        
        enum Sizes {
            static var btnOkSize: CGSize { .init(width: SizeNames.size_13.cgFloat, height: SizeNames.size_8.cgFloat) }
            static var btnDismissSize: CGSize { .init(width: SizeNames.size_15.cgFloat, height: SizeNames.size_10.cgFloat) }
            static var imageModeWidth: CGFloat {SizeNames.size_9.cgFloat}
            static var imageModeHeight: CGFloat {SizeNames.size_9.cgFloat}
            static var txtFieldWidth: CGFloat {SizeNames.size_20.cgFloat}
        }
        
        //
        // Constants
        //
        
        enum Constants {
            static var screenHorizontalMargin: CGFloat { SizeNames.defaultMargin * 2}
        }
        
        //
        // ViewModelInput: ViewController -> ViewModel
        // (The things that our ViewModel can do)
        // struct naming convention: ViewModelInput, allways, Hashable allways

        #warning("Tutorial: The things that our ViewModel can do")
        enum ViewModelInput {

            struct InitialSetup: Hashable {
                let city: String
                let imageDark: UIImage
                let imageLight: UIImage
                let postalCode: String
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

                case routeToSampleScreen
                case routeToDismiss
                case handleBtnOKTapped(postalcode: String)
                
                case handle(user: String, password: String)
            }
        }

        //
        // ViewOutput: View -> ViewController
        // (The things that our view can tell to the ViewController that happened (from UI point of view)
        // struct naming convention: ViewOutput, allways, Hashable allways
        
        #warning("Tutorial: The things that our view can tell to the ViewController that happened (from UI point of view")
        public enum ViewOutput {
            public enum Action: Hashable {
                case btnDismissTapped
                case userTyped(user: String, password: String)
                case btnOKTapped(postalcode: String)
            }
        }

        //
        // ViewInput: ViewModel -> View
        // (The things that our View can do/receive)
        // struct naming convention: ViewInput, allways, Hashable allways

        #warning("Tutorial: The things that our View can do/receive")
        public enum ViewInput {
  
            /// __ViewInput.ViewData__: Information sent from ViewModel to View. Should allways be _Hashable_ and _Enum_
            public enum ViewData: Hashable {
                case displayScreenBlockingMessage(value: String, type: AlertType)
                case nevesView(user: String, password: String, message: String, isVisible: Bool)
                case displayData(city: String, imageLight: UIImage, imageDark: UIImage)
                case displayMessage(message: String)
            }
        }
    }
}

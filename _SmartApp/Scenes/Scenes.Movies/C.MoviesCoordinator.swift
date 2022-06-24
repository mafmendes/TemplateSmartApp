//
//  C.MoviesCoordinator.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 09/06/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation
import UIKit
import Combine
//
import BaseUI
import Common
import DevTools

#warning("Tutorial: C._xxx_Coordinator files ->")

//
// C.MoviesCoordinator files are used for:
//  - Routing
//
// Naming convention: Given a Scene named Movies -> MoviesCoordinator
//

extension C {
    final class MoviesCoordinator: C.BaseCoordinator, MoviesCoordinatorProtocol, GenericSceneCoordinatorProtocol {
        
        var coordinatorIsCompleted: (() -> Void)?
        var cancelBag: CancelBag = CancelBag()
        private(set) weak var viewController: UIViewController?
        var viewControllerProtocol: MoviesViewControllerProtocol? {
            if let result = viewController as? MoviesViewControllerProtocol {
                return result
            }
            if let navigationController = viewController as? UINavigationController {
                if let result = navigationController.viewControllers.first as? MoviesViewControllerProtocol {
                    return result
                }
            }
            return nil
        }
        
        init(viewController: UIViewController) {
            self.viewController = viewController
        }

        override func start() {
            // Insert logic to run before this flow starts
            DevTools.Log.trace("\(Self.self) Coordinator started by [\(SceneDelegate.tabBarController.className)]", .generic)
        }
        
        init(navigationController: UIViewController?) {
            self.viewController = navigationController?.embeddedInNavigationController()
        }
        
        func perform(_ action: Action) {
            switch action {
            
            case .softReLoad:
                softReload()
                
            case .dismiss:
                dismiss(viewController: viewController, from: viewController, animated: true)
            
            case .sampleScreen(let viewModelSetup):
                if let viewModelSetup = viewModelSetup {
                    // New instance with a ViewModel WITH data
                    guard let vc = VC.MoviesViewController.instance(with: viewModelSetup) else { return }
                    present(viewController: vc, from: viewController, animated: true)
                } else {
                    // New instance with a ViewModel WITHOUT data
                    guard let vc = VC.MoviesViewController.instance() else { return }
                    present(viewController: vc, from: viewController, animated: true)
                }
            case .cellPressedNewScreen(let viewModelSetup):
                if let viewModelSetup = viewModelSetup {
                    // New instance with a ViewModel WITH data
                    guard let vc = VC.MovieScreenDetailViewController.instance(with: viewModelSetup) else { return }
                    push(viewController: vc, from: viewController, animated: true)
                } else {
                    // New instance with a ViewModel WITHOUT data
                    guard let vc = VC.MovieScreenDetailViewController.instance() else { return }
                    push(viewController: vc, from: viewController, animated: true)
                }
            }
        }
    }
}

extension C.MoviesCoordinator {
    enum Action: Hashable {
        case softReLoad // Use to put the screen/view on his initial state, (not necessaring reload all the data)
        case dismiss
        case sampleScreen(viewModelSetup: VM.Movies.ViewModelInput.InitialSetup?)
        case cellPressedNewScreen(viewModelSetup: VM.MovieScreenDetail.ViewModelInput.InitialSetup?)
    }
}

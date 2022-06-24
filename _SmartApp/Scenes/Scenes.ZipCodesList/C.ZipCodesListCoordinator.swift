//
//  C.ZipCodesListCoordinator.swift
//  SmartApp
//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation
import UIKit
import Combine
//
import BaseUI
import Common
import DevTools

//
// C.ZipCodesListCoordinator files are used for:
//  - Routing
//
// Naming convention: Given a Scene named ZipCodesList -> ZipCodesListCoordinator
//

extension C {
    final class ZipCodesListCoordinator: C.BaseCoordinator, ZipCodesListCoordinatorProtocol, GenericSceneCoordinatorProtocol {
        
        var coordinatorIsCompleted: (() -> Void)?
        var cancelBag: CancelBag = CancelBag()
        private(set) weak var viewController: UIViewController?
        var viewControllerProtocol: ZipCodesListViewControllerProtocol? {
            if let result = viewController as? ZipCodesListViewControllerProtocol {
                return result
            }
            if let navigationController = viewController as? UINavigationController {
                if let result = navigationController.viewControllers.first as? ZipCodesListViewControllerProtocol {
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
                guard let vc = VC.ZipCodesListViewController.instance(with: viewModelSetup) else { return }
                present(viewController: vc, from: viewController, animated: true)
            }
        }
    }
}

extension C.ZipCodesListCoordinator {
    enum Action: Hashable {
        case softReLoad // Use to put the screen/view on his initial state, (not necessaring reload all the data)
        case dismiss
        case sampleScreen(viewModelSetup: VM.ZipCodesList.ViewModelInput.InitialSetup?)
    }
}

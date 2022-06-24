//
//  C.ZipCodesListUICoordinator.swift
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
// C.ZipCodesListUICoordinator files are used for:
//  - Routing
//
// Naming convention: Given a Scene named ZipCodesListUI -> ZipCodesListUICoordinator
//

extension C {
    final class ZipCodesListUICoordinator: C.BaseCoordinator, ZipCodesListUICoordinatorProtocol, GenericSceneCoordinatorProtocol {
        
        var coordinatorIsCompleted: (() -> Void)?
        var cancelBag: CancelBag = CancelBag()
        private(set) weak var viewController: UIViewController?
        var viewControllerProtocol: ZipCodesListUIViewControllerProtocol? {
            if let result = viewController as? ZipCodesListUIViewControllerProtocol {
                return result
            }
            if let navigationController = viewController as? UINavigationController {
                if let result = navigationController.viewControllers.first as? ZipCodesListUIViewControllerProtocol {
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
                guard let vc = VC.ZipCodesListUIViewController.instance(with: viewModelSetup) else { return }
                present(viewController: vc, from: viewController, animated: true)
                
            case .newScreen(viewSetup: let viewSetup):
                guard let vc = VC.TitleViewController.instance(with: viewSetup!) else { return }
                present(viewController: vc, from: viewController, animated: true)
            }
        }
    }
}

extension C.ZipCodesListUICoordinator {
    enum Action: Hashable {
        case softReLoad // Use to put the screen/view on his initial state, (not necessaring reload all the data)
        case dismiss
        case sampleScreen(viewModelSetup: VM.ZipCodesListUI.ViewModelInput.InitialSetup?)
        case newScreen(viewSetup: VM.Title.ViewModelInput.InitialSetup?)
    }
}

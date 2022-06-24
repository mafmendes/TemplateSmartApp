//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
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
// C.___VARIABLE_sceneName___Coordinator files are used for:
//  - Routing
//
// Naming convention: Given a Scene named ___VARIABLE_sceneName___ -> ___VARIABLE_sceneName___Coordinator
//

extension C {
    final class ___VARIABLE_sceneName___Coordinator: C.BaseCoordinator, ___VARIABLE_sceneName___CoordinatorProtocol, GenericSceneCoordinatorProtocol {
        
        var coordinatorIsCompleted: (() -> Void)?
        var cancelBag: CancelBag = CancelBag()
        private(set) weak var viewController: UIViewController?
        var viewControllerProtocol: ___VARIABLE_sceneName___ViewControllerProtocol? {
            if let result = viewController as? ___VARIABLE_sceneName___ViewControllerProtocol {
                return result
            }
            if let navigationController = viewController as? UINavigationController {
                if let result = navigationController.viewControllers.first as? ___VARIABLE_sceneName___ViewControllerProtocol {
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
                    guard let vc = VC.___VARIABLE_sceneName___ViewController.instance(with: viewModelSetup) else { return }
                    present(viewController: vc, from: viewController, animated: true)
                } else {
                    // New instance with a ViewModel WITHOUT data
                    guard let vc = VC.___VARIABLE_sceneName___ViewController.instance() else { return }
                    present(viewController: vc, from: viewController, animated: true)
                }
            }
        }
    }
}

extension C.___VARIABLE_sceneName___Coordinator {
    enum Action: Hashable {
        case softReLoad // Use to put the screen/view on his initial state, (not necessaring reload all the data)
        case dismiss
        case sampleScreen(viewModelSetup: VM.___VARIABLE_sceneName___.ViewModelInput.InitialSetup?)
    }
}

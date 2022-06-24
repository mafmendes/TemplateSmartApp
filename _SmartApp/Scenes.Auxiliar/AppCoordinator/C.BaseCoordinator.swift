//
//  BaseCoordinator.swift
//  SmartApp
//
//  Created by Santos, Ricardo Patricio dos  on 08/05/2021.
//

import Foundation
import UIKit
//
import Common
import BaseUI
import DevTools

/**
 
 `GenericSceneCoordinatorProtocol` :
    * ALL the App __Scenes coordinators__ implement `GenericSceneCoordinatorProtocol`
    * Defines `var coordinatorIsCompleted: (() -> Void)?`
    * Defines `func perform(_ action: Action)`
    * Defines `var cancelBag: CancelBag`
 
 `BaseCoordinatorProtocol`
    * States that a coordinator must implement
        * `func start`
        * `var childCoordinators: [BaseCoordinatorProtocol]`
 
 `class BaseCoordinator: BaseCoordinatorProtocol` :
    * __ALL__  Coordinators including _Scenes coordinators_,  and`C.AppCoordinator`, heritage `BaseCoordinator`
    * Provides a bridge to the navigation (`BaseCoordinatorProtocol`)
    * Defines and implements `func goTo(tab: C.TabBarCoordinator.Action)`
    * Defines and implements `func present(viewController: UIViewController, from: ...`
    * Defines and implements `func push(viewController: UIViewController, from: ...`
    * Defines and implements  `func dismiss(viewController: UIViewController?, from: ...`
    * Defines and implements `func store(coordinator: BaseCoordinatorProtocol)`
    * Defines and implements `func free(coordinator: BaseCoordinatorProtocol)`

 `class AppMainCoordinator: C.BaseCoordinator` :
    * Application start coordinator.
    * Constains reference to app sub flows (login or tab)
  
 `class ___VARIABLE_sceneName___Coordinator: C.BaseCoordinator, GenericCoordinatorProtocol`
 */

//
// MARK: - BaseCoordinatorProtocol
//

protocol GenericSceneCoordinatorProtocol {
    associatedtype Action = Hashable
    var coordinatorIsCompleted: (() -> Void)? { get }
    var cancelBag: CancelBag { get set }
    func perform(_ action: Action)
}

//
// MARK: - BaseCoordinatorProtocol
//

protocol BaseCoordinatorProtocol: AnyObject {
    var childCoordinators: [BaseCoordinatorProtocol] { get set }
    func start()
}

//
// MARK: - BaseCoordinator
//

extension C {
    class BaseCoordinator: BaseCoordinatorProtocol {
        var childViewControllers: [UIViewController] = []
        var childCoordinators: [BaseCoordinatorProtocol] = []

        func start() {
            fatalError("Children should implement `start`.")
        }
        
        func goTo(tab: C.TabBarCoordinator.Action) {
            DevTools.Log.trace("Will route to \(tab)", .generic)
            //SceneDelegate.tabBarController.toolBarStateOutput.value.send(.taped(index: 0, id: tab.accessibilityIdentifier, state: nil))
        }
        
        func softReload() {
            childViewControllers.forEach { some in
                dismiss(viewController: some,
                        from: nil,
                        animated: true)
            }
            childViewControllers.removeAll()
        }
        
        func present(viewController: UIViewController,
                     from: UIViewController?,
                     animated: Bool) {
            DevTools.Log.trace("Will present [\(String(describing: viewController.className))]", .generic)
            from?.present(viewController, animated: animated, completion: nil)
        }
        
        func push(viewController: UIViewController,
                  from: UIViewController?,
                  animated: Bool) {
            DevTools.Log.trace("Will push [\(String(describing: viewController.className))]", .generic)
            if let navigationController = from?.navigationController {
                navigationController.pushViewController(viewController, animated: animated)
            } else {
                present(viewController: viewController, from: from, animated: animated)
                DevTools.assert(false, message: "Not predicted")
            }
        }
        
        func dismiss(viewController: UIViewController?,
                     from: UIViewController?,
                     animated: Bool) {
            DevTools.Log.trace("Will dismiss [\(String(describing: viewController?.className))]", .generic)
            if let navigationController = viewController?.navigationController {
                navigationController.popViewController(animated: animated)
            } else {
                viewController?.dismiss(animated: animated, completion: nil)
            }
        }
      
        func store(coordinator: BaseCoordinatorProtocol) {
            childCoordinators.append(coordinator)
        }

        func free(coordinator: BaseCoordinatorProtocol) {
            childCoordinators = childCoordinators.filter { $0 !== coordinator }
        }
    }
}

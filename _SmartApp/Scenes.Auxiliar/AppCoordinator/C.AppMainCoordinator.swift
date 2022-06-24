//
//  Created by Santos, Ricardo Patricio dos  on 16/04/2021.
//

import Foundation
import UIKit
//
import Common
import BaseUI
import DevTools
import AppCore

//
// https://benoitpasquier.com/coordinator-pattern-swift/
// https://quickbirdstudios.com/blog/coordinator-pattern-in-swiftui/
//

//
// MARK: - AppCoordinator
//

extension C {
    class AppMainCoordinator: C.BaseCoordinator {

        enum Flow {
            case tabBarFlow
            case loginFlow
        }
        
        private let window: UIWindow
        private var tabBarCoordinator: C.TabBarCoordinator?
        private var loginCoordinator: C.___VARIABLE_sceneName___Coordinator?
        private var lastFlow: Flow?
        private let cancelBag: CancelBag = CancelBag()
        
        init(window: UIWindow) {
            self.window = window
            super.init()
        }
        
        func end(flow: Flow) {
            switch flow {
            case .loginFlow:  loginCoordinator?.coordinatorIsCompleted?()
            case .tabBarFlow: tabBarCoordinator?.coordinatorIsCompleted?()
            }
        }
        
        func start(flow: Flow, model: Any? = nil) {
            defer {
                lastFlow = flow
            }
            switch flow {
                
            case .tabBarFlow:
                tabBarCoordinator = C.TabBarCoordinator(viewController: SceneDelegate.rootViewController)
                store(coordinator: tabBarCoordinator!)
                tabBarCoordinator?.coordinatorIsCompleted = { [weak self] in
                    if let coordinator = self?.tabBarCoordinator {
                        self?.free(coordinator: coordinator)
                    }
                }
                tabBarCoordinator?.start()
                window.rootViewController = tabBarCoordinator?.viewController
            case .loginFlow:
                if let name = model as? String {
                    let viewModelSetup = VM.___VARIABLE_sceneName___.ViewModelInput.InitialSetup(name: name)
                    if let viewController = VC.___VARIABLE_sceneName___ViewController.instance(with: viewModelSetup) {
                        loginCoordinator = C.___VARIABLE_sceneName___Coordinator(viewController: viewController)
                        store(coordinator: loginCoordinator!)
                        loginCoordinator?.coordinatorIsCompleted = { [weak self] in
                            if let coordinator = self?.loginCoordinator {
                                self?.free(coordinator: coordinator)
                            }
                        }
                        loginCoordinator?.start()
                        window.rootViewController?.present(viewController, animated: true, completion: nil)
                    }
                }
            }
            window.makeKeyAndVisible()
        }
        
        override func start() {
            start(flow: .tabBarFlow)
            SampleUseCase1.output.value.sink { [weak self] some in
                switch some {
                case .userDidLogin(user: let user):
                    #warning("Tutorial: By listening the UseCase events, we could pottentially trigger some navigation here")
                    DevTools.Log.debug("User did login. Trigger some navigation - Parte 2", .generic)
                    self?.end(flow: .tabBarFlow)
                    self?.start(flow: .loginFlow, model: user)
                }
            }.store(in: self.cancelBag)
        }
    }
}

//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
import Swinject
//
import BaseUI
import AppDomain
import AppCore

#warning("Tutorial: DI._xxx_Assembly files ->")

//
// DI.___VARIABLE_sceneName___Assembly.swift files are used for:
//  - Resolve a Scene dependencies
//
// Naming convention: Given a Scene named ___VARIABLE_sceneName___ -> ___VARIABLE_sceneName___Assembly
//

extension DI {
    class ___VARIABLE_sceneName___Assembly: Assembly {

        func assemble(container: Container) {

            // Resolving the Coordinator
            container.register(___VARIABLE_sceneName___CoordinatorProtocol.self) { (/*resolver*/ _, arg: VC.___VARIABLE_sceneName___ViewController) in
                let resolving = C.___VARIABLE_sceneName___Coordinator(viewController: arg)
                return resolving
            }
      
            // Resolving the ViewController with an (optional) parameter for the ViewModel initial state
            container.register(___VARIABLE_sceneName___ViewControllerProtocol.self) { (resolver, arg: VM.___VARIABLE_sceneName___.ViewModelInput.InitialSetup?) in
                let resolving = VC.___VARIABLE_sceneName___ViewController()
                if let arg = arg {
                    resolving.viewModelSetup = arg
                }
                
                // ViewModel init
                resolving.viewModel = .init(resolving.genericView.input,
                                            resolving.coordinatorActions,
                                            resolving.viewModelSetup)
                resolving.viewModel?.sampleUseCase1 = CoreProtocolsResolved.sampleUseCase1Protocol // Resolving UseCases that ViewModel knows
                resolving.viewModel?.sampleUseCase2 = CoreProtocolsResolved.sampleUseCase2Protocol // Resolving UseCases that ViewModel knows
                resolving.coordinator = resolver.resolve(___VARIABLE_sceneName___CoordinatorProtocol.self, argument: resolving) // Resolving Coordinator
                return resolving
            }

        }
    }
}

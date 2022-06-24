//
//  DI.MovieScreenDetailAssembly.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 22/06/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
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
// DI.MovieScreenDetailAssembly.swift files are used for:
//  - Resolve a Scene dependencies
//
// Naming convention: Given a Scene named MovieScreenDetail -> MovieScreenDetailAssembly
//

extension DI {
    class MovieScreenDetailAssembly: Assembly {

        func assemble(container: Container) {

            // Resolving the Coordinator
            container.register(MovieScreenDetailCoordinatorProtocol.self) { (/*resolver*/ _, arg: VC.MovieScreenDetailViewController) in
                let resolving = C.MovieScreenDetailCoordinator(viewController: arg)
                return resolving
            }
      
            // Resolving the ViewController with an (optional) parameter for the ViewModel initial state
            container.register(MovieScreenDetailViewControllerProtocol.self) { (resolver, arg: VM.MovieScreenDetail.ViewModelInput.InitialSetup?) in
                let resolving = VC.MovieScreenDetailViewController()
                if let arg = arg {
                    resolving.viewModelSetup = arg
                }
                
                // ViewModel init
                resolving.viewModel = .init(resolving.genericView.input,
                                            resolving.coordinatorActions,
                                            resolving.viewModelSetup)
                resolving.viewModel?.sampleUseCase1Protocol = CoreProtocolsResolved.sampleUseCase1Protocol   // Resolving UseCases that ViewModel knows
                resolving.viewModel?.sampleUseCase2Protocol = CoreProtocolsResolved.sampleUseCase2Protocol // Resolving UseCases that ViewModel knows
                resolving.coordinator = resolver.resolve(MovieScreenDetailCoordinatorProtocol.self, argument: resolving) // Resolving Coordinator
                return resolving
            }

        }
    }
}

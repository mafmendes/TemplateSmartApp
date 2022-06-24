//
//  DI.MoviesAssembly.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 09/06/2022.
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
// DI.MoviesAssembly.swift files are used for:
//  - Resolve a Scene dependencies
//
// Naming convention: Given a Scene named Movies -> MoviesAssembly
//

extension DI {
    class MoviesAssembly: Assembly {

        func assemble(container: Container) {

            // Resolving the Coordinator
            container.register(MoviesCoordinatorProtocol.self) { (/*resolver*/ _, arg: VC.MoviesViewController) in
                let resolving = C.MoviesCoordinator(viewController: arg)
                return resolving
            }
      
            // Resolving the ViewController with an (optional) parameter for the ViewModel initial state
            container.register(MoviesViewControllerProtocol.self) { (resolver, arg: VM.Movies.ViewModelInput.InitialSetup?) in
                let resolving = VC.MoviesViewController()
                if let arg = arg {
                    resolving.viewModelSetup = arg
                }
                
                // ViewModel init
                resolving.viewModel = .init(resolving.genericView.input,
                                            resolving.coordinatorActions,
                                            resolving.viewModelSetup)
                resolving.viewModel?.sampleUseCase1Protocol = CoreProtocolsResolved.sampleUseCase1Protocol   // Resolving UseCases that ViewModel knows
                resolving.viewModel?.sampleUseCase2Protocol = CoreProtocolsResolved.sampleUseCase2Protocol // Resolving UseCases that ViewModel knows
                resolving.coordinator = resolver.resolve(MoviesCoordinatorProtocol.self, argument: resolving) // Resolving Coordinator
                return resolving
            }

        }
    }
}

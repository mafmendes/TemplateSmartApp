//
//  DI.TitleAssembly.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 14/04/2022.
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
// DI.TitleAssembly.swift files are used for:
//  - Resolve a Scene dependencies
//
// Naming convention: Given a Scene named Title -> TitleAssembly
//

extension DI {
    class TitleAssembly: Assembly {

        func assemble(container: Container) {

            // Resolving the Coordinator
            container.register(TitleCoordinatorProtocol.self) { (/*resolver*/ _, arg: VC.TitleViewController) in
                let resolving = C.TitleCoordinator(viewController: arg)
                return resolving
            }
      
            // Resolving the ViewController with an (optional) parameter for the ViewModel initial state
            container.register(TitleViewControllerProtocol.self) { (resolver, arg: VM.Title.ViewModelInput.InitialSetup?) in
                let resolving = VC.TitleViewController()
                if let arg = arg {
                    resolving.viewModelSetup = arg
                }
                
                // ViewModel init
                resolving.viewModel = .init(resolving.genericView.input,
                                            resolving.coordinatorActions,
                                            resolving.viewModelSetup)
                resolving.viewModel?.sampleUseCase1Protocol = CoreProtocolsResolved.sampleUseCase1Protocol   // Resolving UseCases that ViewModel knows
                resolving.viewModel?.sampleUseCase2Protocol = CoreProtocolsResolved.sampleUseCase2Protocol // Resolving UseCases that ViewModel knows
                resolving.coordinator = resolver.resolve(TitleCoordinatorProtocol.self, argument: resolving) // Resolving Coordinator
                return resolving
            }

        }
    }
}

//
//  DI.TextFieldAssembly.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 11/04/2022.
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
// DI.TextFieldAssembly.swift files are used for:
//  - Resolve a Scene dependencies
//
// Naming convention: Given a Scene named TextField -> TextFieldAssembly
//

extension DI {
    class TextFieldAssembly: Assembly {

        func assemble(container: Container) {

            // Resolving the Coordinator
            container.register(TextFieldCoordinatorProtocol.self) { (/*resolver*/ _, arg: VC.TextFieldViewController) in
                let resolving = C.TextFieldCoordinator(viewController: arg)
                return resolving
            }
      
            // Resolving the ViewController with an (optional) parameter for the ViewModel initial state
            container.register(TextFieldViewControllerProtocol.self) { (resolver, arg: VM.TextField.ViewModelInput.InitialSetup?) in
                let resolving = VC.TextFieldViewController()
                if let arg = arg {
                    resolving.viewModelSetup = arg
                }
                
                // ViewModel init
                resolving.viewModel = .init(resolving.genericView.input,
                                            resolving.coordinatorActions,
                                            resolving.viewModelSetup)
                resolving.viewModel?.sampleUseCase1Protocol = CoreProtocolsResolved.sampleUseCase1Protocol   // Resolving UseCases that ViewModel knows
                resolving.viewModel?.sampleUseCase2Protocol = CoreProtocolsResolved.sampleUseCase2Protocol // Resolving UseCases that ViewModel knows
                resolving.coordinator = resolver.resolve(TextFieldCoordinatorProtocol.self, argument: resolving) // Resolving Coordinator
                return resolving
            }

        }
    }
}

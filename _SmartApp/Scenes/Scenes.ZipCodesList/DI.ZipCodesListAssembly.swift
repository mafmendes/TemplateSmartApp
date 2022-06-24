//
//  DI.ZipCodesListAssembly.swift
//  SmartApp
//
//  Created by Neves, Pedro Cardoso on 16/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
import Swinject
//
import BaseUI
import AppDomain
import AppCore

//
// DI.ZipCodesListAssembly.swift files are used for:
//  - Resolve a Scene dependencies
//
// Naming convention: Given a Scene named ZipCodesList -> ZipCodesListAssembly
//

extension DI {
    class ZipCodesListAssembly: Assembly {

        func assemble(container: Container) {

            container.register(ZipCodesListCoordinatorProtocol.self) { (/*resolver*/ _, arg: VC.ZipCodesListViewController) in
                let resolving = C.ZipCodesListCoordinator(viewController: arg)
                return resolving
            }
                    
            container.register(ZipCodesListViewControllerProtocol.self) { (resolver, arg: VM.ZipCodesList.ViewModelInput.InitialSetup?) in
                let resolving = VC.ZipCodesListViewController()
                if let arg = arg {
                    resolving.viewModelSetup = arg
                }
                resolving.viewModel = .init(resolving.genericView.input,
                                            resolving.coordinatorActions,
                                            resolving.viewModelSetup)
                resolving.viewModel?.sampleUseCase1 = CoreProtocolsResolved.sampleUseCase1Protocol // Resolving UseCases that ViewModel knows
                resolving.viewModel?.sampleUseCase2 = CoreProtocolsResolved.sampleUseCase2Protocol // Resolving UseCases that ViewModel knows
                resolving.coordenator = resolver.resolve(ZipCodesListCoordinatorProtocol.self, argument: resolving)
                return resolving
            }

        }
    }
}

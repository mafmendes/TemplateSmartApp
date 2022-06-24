//
//  DI.ZipCodesListUIAssembly.swift
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
// DI.ZipCodesListUIAssembly.swift files are used for:
//  - Resolve a Scene dependencies
//
// Naming convention: Given a Scene named ZipCodesListUI -> ZipCodesListUIAssembly
//

extension DI {
    class ZipCodesListUIAssembly: Assembly {

        func assemble(container: Container) {

            container.register(ZipCodesListUICoordinatorProtocol.self) { (/*resolver*/ _, arg: VC.ZipCodesListUIViewController) in
                let resolving = C.ZipCodesListUICoordinator(viewController: arg)
                return resolving
            }
                    
            container.register(ZipCodesListUIViewControllerProtocol.self) { (resolver, arg: VM.ZipCodesListUI.ViewModelInput.InitialSetup?) in
                let resolving = VC.ZipCodesListUIViewController()
                if let arg = arg {
                    resolving.viewModelSetup = arg
                }
                resolving.viewModel = .init(resolving.genericView.input,
                                            resolving.coordinatorActions,
                                            resolving.viewModelSetup)
                resolving.viewModel?.sampleUseCase1 = CoreProtocolsResolved.sampleUseCase1Protocol // Resolving UseCases that ViewModel knows
                resolving.viewModel?.sampleUseCase2 = CoreProtocolsResolved.sampleUseCase2Protocol // Resolving UseCases that ViewModel knows
                resolving.coordenator = resolver.resolve(ZipCodesListUICoordinatorProtocol.self, argument: resolving)
                return resolving
            }

        }
    }
}

//
//  C.ZipCodesListUIConfigurator.swift
//  SmartApp
//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseUI

//
// C.ZipCodesListUIConfigurator files are used for:
//  - Return C.ZipCodesListUIConfiguratorViewController instances
//
// Naming convention: Given a Scene named C.ZipCodesListUIConfigurator -> C.ZipCodesListUIConfiguratorConfigurator
//

extension VC.ZipCodesListUIViewController {
    // Sugar for new instances
    static func instance(with viewModelSetup: VM.ZipCodesListUI.ViewModelInput.InitialSetup? = nil) -> VC.ZipCodesListUIViewController? {
        C.ZipCodesListUIConfigurator.setupV2(viewModelSetup: viewModelSetup)
    }
}

extension C {
    
    struct ZipCodesListUIConfigurator {
        static func setupV1(viewModel: VM.ZipCodesListUIViewModel.ViewModelSetup? = nil) -> VC.ZipCodesListUIViewController? {
            let viewController = VC.ZipCodesListUIViewController()
            viewController.viewModelSetup = viewModel
            return viewController
        }

        static func setupV2(viewModelSetup: VM.ZipCodesListUIViewModel.ViewModelSetup? = nil) -> VC.ZipCodesListUIViewController? {
            let container = SmartAppNameSpace.SmartAppAssembly.shared.container
            return container.resolve(ZipCodesListUIViewControllerProtocol.self, argument: viewModelSetup) as? VC.ZipCodesListUIViewController
        }
    
    }
}

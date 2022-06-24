//
//  C.ZipCodesListConfigurator.swift
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
// C.ZipCodesListConfigurator files are used for:
//  - Return C.ZipCodesListConfiguratorViewController instances
//
// Naming convention: Given a Scene named C.ZipCodesListConfigurator -> C.ZipCodesListConfiguratorConfigurator
//

extension VC.ZipCodesListViewController {
    // Sugar for new instances
    static func instance(with viewModelSetup: VM.ZipCodesList.ViewModelInput.InitialSetup? = nil) -> VC.ZipCodesListViewController? {
        C.ZipCodesListConfigurator.setupV2(viewModelSetup: viewModelSetup)
    }
}

extension C {
    
    struct ZipCodesListConfigurator {
        static func setupV1(viewModel: VM.ZipCodesListViewModel.ViewModelSetup? = nil) -> VC.ZipCodesListViewController? {
            let viewController = VC.ZipCodesListViewController()
            viewController.viewModelSetup = viewModel
            return viewController
        }

        static func setupV2(viewModelSetup: VM.ZipCodesListViewModel.ViewModelSetup? = nil) -> VC.ZipCodesListViewController? {
            let container = SmartAppNameSpace.SmartAppAssembly.shared.container
            return container.resolve(ZipCodesListViewControllerProtocol.self, argument: viewModelSetup) as? VC.ZipCodesListViewController
        }
    
    }
}

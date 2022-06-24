//
//  C.MovieScreenDetailConfigurator.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 22/06/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseUI

#warning("Tutorial: C._xxx_Configurator files ->")
//
// C.MovieScreenDetailConfigurator files are used for:
//  - Return C.MovieScreenDetailConfiguratorViewController instances
//
// Naming convention: Given a Scene named C.MovieScreenDetailConfigurator -> C.MovieScreenDetailConfiguratorConfigurator
//

extension VC.MovieScreenDetailViewController {
    // Sugar for new instances passing a starting ViewModel
    static func instance(with viewModelSetup: VM.MovieScreenDetail.ViewModelInput.InitialSetup) -> VC.MovieScreenDetailViewController? {
        C.MovieScreenDetailConfigurator.setupV2(viewModelSetup: viewModelSetup)
    }
    
    // Sugar for new instances
    static func instance() -> VC.MovieScreenDetailViewController? {
        C.MovieScreenDetailConfigurator.setupV2(viewModelSetup: nil)
    }
}

extension C {
    
    struct MovieScreenDetailConfigurator {
        
        // Setting up a new ViewController instance were we setup the ViewModel MANUALLY
        static func setupV1(viewModel: VM.MovieScreenDetailViewModel.ViewModelSetup? = nil) -> VC.MovieScreenDetailViewController? {
            let viewController = VC.MovieScreenDetailViewController()
            viewController.viewModelSetup = viewModel
            return viewController
        }

        // Setting up a new ViewController instance were we setup the ViewModel using DEPENDENCY INJECTION
        static func setupV2(viewModelSetup: VM.MovieScreenDetailViewModel.ViewModelSetup? = nil) -> VC.MovieScreenDetailViewController? {
            let container = SmartAppNameSpace.SmartAppAssembly.shared.container
            return container.resolve(MovieScreenDetailViewControllerProtocol.self,
                                     argument: viewModelSetup) as? VC.MovieScreenDetailViewController
        }
    
    }
}

//
//  C.MoviesConfigurator.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 09/06/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseUI

#warning("Tutorial: C._xxx_Configurator files ->")
//
// C.MoviesConfigurator files are used for:
//  - Return C.MoviesConfiguratorViewController instances
//
// Naming convention: Given a Scene named C.MoviesConfigurator -> C.MoviesConfiguratorConfigurator
//

extension VC.MoviesViewController {
    // Sugar for new instances passing a starting ViewModel
    static func instance(with viewModelSetup: VM.Movies.ViewModelInput.InitialSetup) -> VC.MoviesViewController? {
        C.MoviesConfigurator.setupV2(viewModelSetup: viewModelSetup)
    }
    
    // Sugar for new instances
    static func instance() -> VC.MoviesViewController? {
        C.MoviesConfigurator.setupV2(viewModelSetup: nil)
    }
}

extension C {
    
    struct MoviesConfigurator {
        
        // Setting up a new ViewController instance were we setup the ViewModel MANUALLY
        static func setupV1(viewModel: VM.MoviesViewModel.ViewModelSetup? = nil) -> VC.MoviesViewController? {
            let viewController = VC.MoviesViewController()
            viewController.viewModelSetup = viewModel
            return viewController
        }

        // Setting up a new ViewController instance were we setup the ViewModel using DEPENDENCY INJECTION
        static func setupV2(viewModelSetup: VM.MoviesViewModel.ViewModelSetup? = nil) -> VC.MoviesViewController? {
            let container = SmartAppNameSpace.SmartAppAssembly.shared.container
            return container.resolve(MoviesViewControllerProtocol.self,
                                     argument: viewModelSetup) as? VC.MoviesViewController
        }
    
    }
}

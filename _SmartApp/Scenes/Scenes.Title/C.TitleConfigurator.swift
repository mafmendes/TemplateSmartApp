//
//  C.TitleConfigurator.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 14/04/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseUI

#warning("Tutorial: C._xxx_Configurator files ->")
//
// C.TitleConfigurator files are used for:
//  - Return C.TitleConfiguratorViewController instances
//
// Naming convention: Given a Scene named C.TitleConfigurator -> C.TitleConfiguratorConfigurator
//

extension VC.TitleViewController {
    // Sugar for new instances passing a starting ViewModel
    static func instance(with viewModelSetup: VM.Title.ViewModelInput.InitialSetup) -> VC.TitleViewController? {
        C.TitleConfigurator.setupV2(viewModelSetup: viewModelSetup)
    }
    
    // Sugar for new instances
    static func instance() -> VC.TitleViewController? {
        C.TitleConfigurator.setupV2(viewModelSetup: nil)
    }
}

extension C {
    
    struct TitleConfigurator {
        
        // Setting up a new ViewController instance were we setup the ViewModel MANUALLY
        static func setupV1(viewModel: VM.TitleViewModel.ViewModelSetup? = nil) -> VC.TitleViewController? {
            let viewController = VC.TitleViewController()
            viewController.viewModelSetup = viewModel
            return viewController
        }

        // Setting up a new ViewController instance were we setup the ViewModel using DEPENDENCY INJECTION
        static func setupV2(viewModelSetup: VM.TitleViewModel.ViewModelSetup? = nil) -> VC.TitleViewController? {
            let container = SmartAppNameSpace.SmartAppAssembly.shared.container
            return container.resolve(TitleViewControllerProtocol.self,
                                     argument: viewModelSetup) as? VC.TitleViewController
        }
    
    }
}

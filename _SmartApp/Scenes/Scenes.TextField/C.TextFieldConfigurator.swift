//
//  C.TextFieldConfigurator.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 11/04/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseUI

#warning("Tutorial: C._xxx_Configurator files ->")
//
// C.TextFieldConfigurator files are used for:
//  - Return C.TextFieldConfiguratorViewController instances
//
// Naming convention: Given a Scene named C.TextFieldConfigurator -> C.TextFieldConfiguratorConfigurator
//

extension VC.TextFieldViewController {
    // Sugar for new instances passing a starting ViewModel
    static func instance(with viewModelSetup: VM.TextField.ViewModelInput.InitialSetup) -> VC.TextFieldViewController? {
        C.TextFieldConfigurator.setupV2(viewModelSetup: viewModelSetup)
    }
    
    // Sugar for new instances
    static func instance() -> VC.TextFieldViewController? {
        C.TextFieldConfigurator.setupV2(viewModelSetup: nil)
    }
}

extension C {
    
    struct TextFieldConfigurator {
        
        // Setting up a new ViewController instance were we setup the ViewModel MANUALLY
        static func setupV1(viewModel: VM.TextFieldViewModel.ViewModelSetup? = nil) -> VC.TextFieldViewController? {
            let viewController = VC.TextFieldViewController()
            viewController.viewModelSetup = viewModel
            return viewController
        }

        // Setting up a new ViewController instance were we setup the ViewModel using DEPENDENCY INJECTION
        static func setupV2(viewModelSetup: VM.TextFieldViewModel.ViewModelSetup? = nil) -> VC.TextFieldViewController? {
            let container = SmartAppNameSpace.SmartAppAssembly.shared.container
            return container.resolve(TextFieldViewControllerProtocol.self,
                                     argument: viewModelSetup) as? VC.TextFieldViewController
        }
    
    }
}

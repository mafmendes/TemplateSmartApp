//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseUI

#warning("Tutorial: C._xxx_Configurator files ->")
//
// C.___VARIABLE_sceneName___Configurator files are used for:
//  - Return ___FILEBASENAME___ViewController instances
//
// Naming convention: Given a Scene named ___FILEBASENAME___ -> ___FILEBASENAME___Configurator
//

extension VC.___VARIABLE_sceneName___ViewController {
    // Sugar for new instances passing a starting ViewModel
    static func instance(with viewModelSetup: VM.___VARIABLE_sceneName___.ViewModelInput.InitialSetup) -> VC.___VARIABLE_sceneName___ViewController? {
        C.___VARIABLE_sceneName___Configurator.setupV2(viewModelSetup: viewModelSetup)
    }
    
    // Sugar for new instances
    static func instance() -> VC.___VARIABLE_sceneName___ViewController? {
        C.___VARIABLE_sceneName___Configurator.setupV2(viewModelSetup: nil)
    }
}

extension C {
    
    struct ___VARIABLE_sceneName___Configurator {
        
        // Setting up a new ViewController instance were we setup the ViewModel MANUALLY
        static func setupV1(viewModel: VM.___VARIABLE_sceneName___ViewModel.ViewModelSetup? = nil) -> VC.___VARIABLE_sceneName___ViewController? {
            let viewController = VC.___VARIABLE_sceneName___ViewController()
            viewController.viewModelSetup = viewModel
            return viewController
        }

        // Setting up a new ViewController instance were we setup the ViewModel using DEPENDENCY INJECTION
        static func setupV2(viewModelSetup: VM.___VARIABLE_sceneName___ViewModel.ViewModelSetup? = nil) -> VC.___VARIABLE_sceneName___ViewController? {
            let container = SmartAppNameSpace.SmartAppAssembly.shared.container
            return container.resolve(___VARIABLE_sceneName___ViewControllerProtocol.self,
                                     argument: viewModelSetup) as? VC.___VARIABLE_sceneName___ViewController
        }
    
    }
}

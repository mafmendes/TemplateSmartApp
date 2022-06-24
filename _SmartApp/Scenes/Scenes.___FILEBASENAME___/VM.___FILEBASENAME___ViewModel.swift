//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
import Combine
//
import Common
import Resources
import DevTools
import BaseDomain
import AppDomain
import AppCore
import BaseUI
import AppConstants

#warning("Tutorial: V._xxx_ViewModel files ->")
//
// VM.___VARIABLE_sceneName___ViewModel files are used for:
//  - Responde to UIViewController events [func send(_ action: Action)]
//  - Handle bussiness responses and parse then to the ViewState [func present(action: Action, some: Any?)]
//  - Handle bussiness errors and parse then to the ViewState [func present(error: AppErrors)]
//
// Naming convention: Given a Scene named ___VARIABLE_sceneName___ -> ___VARIABLE_sceneName___ViewModel
//

// MARK: - ___VARIABLE_sceneName___ViewModel

extension VM {
    
    //
    // ViewModel naming convention: Given a Scene named ___VARIABLE_sceneName___ -> ___VARIABLE_sceneName___ViewModel
    //
    
    struct ___VARIABLE_sceneName___ViewModel: ___VARIABLE_sceneName___ViewModelProtocol,
                                              MVVMGenericViewModelProtocol {
        
        //
        // GenericViewModelProtocol
        //
        typealias ViewModelSetup = VM.___VARIABLE_sceneName___.ViewModelInput.InitialSetup
        typealias Action         = VM.___VARIABLE_sceneName___.ViewModelInput.Action
        typealias ViewData       = VM.___VARIABLE_sceneName___.ViewInput.ViewData
        typealias CoordinatorActions = C.___VARIABLE_sceneName___Coordinator.Action
        
        @ObservedObject var viewState: MVVMViewInputObservable<ViewData>
        @ObservedObject var coordinatorActions = GenericObservableObjectForHashable<CoordinatorActions>()
        
        var viewModelSetup: ViewModelSetup?
        
        init(_ viewState: MVVMViewInputObservable<ViewData>,
             _ coordinatorActions: GenericObservableObjectForHashable<CoordinatorActions>,
             _ viewModelSetup: ViewModelSetup?) {
            self.viewState = viewState
            self.coordinatorActions = coordinatorActions
            self.viewModelSetup = viewModelSetup
        }
        
        //
        // Auxiliar vars
        //
        fileprivate var cancelBag = CancelBag()
        fileprivate var changesPublisherBag = CancelBag()

        #warning("Tutorial: ViewModel dependencies (MUST be resolved at DI.___VARIABLE_sceneName___Assembly) ")
        public var sampleUseCase1: SampleUseCase1Protocol!
        public var sampleUseCase2: SampleUseCase2Protocol!
    }
}

//
// MARK: - viewModelSetup : Computed values for UIViewController
//

extension VM.___VARIABLE_sceneName___ViewModel {
    var name: String {
        viewModelSetup?.name ?? ""
    }
}

//
// MARK: - GenericViewModelProtocol functions
//

#warning("Tutorial: V._xxx_ViewModel files [func send] and [func present]")
/**
 * Function `func send(_ action: Action)`: Receives action for the View (View->ViewController->ViewModel), and do something (assync request, routing, etc).
 * Function `func send(_ action: Action)` call `func present(action: Action, some: Any?)` with the response received.
 * Function `func present(action: Action, some: Any?)`, receives something sent from `func send(_ action: Action)` and parses it on a way that the view can read it.
 * Function `func present(error: AppErrors)` handle and fwd errors to the view.
*/

extension VM.___VARIABLE_sceneName___ViewModel {
    
    func send(_ action: Action) {

        DevTools.Log.trace(action, .viewModel)
        
        startObservingVehicleChangesRx()
                
        switch action {
        
        case .softReLoad:
            present(action: action, some: nil)
            
        case .viewLoaded:
            
            if let dataPassedFromPreviousVC = viewModelSetup {
                
                fwdStateToView(.loaded(.canGoBack(canGoBack: true)))
                
                // ViewModel received data to start with!
                // 1 : Display Hello message
                fwdStateToView(.loaded(.displayHello(message: "Hello \(dataPassedFromPreviousVC.name)")))
                
                // 2 : Hide login component
                fwdStateToView(.loaded(.nevesView(user: "",
                                                  password: "",
                                                  message: "",
                                                  isVisible: false)))
            } else {
                
                fwdStateToView(.loaded(.canGoBack(canGoBack: false)))

                fwdStateToView(.loaded(.nevesView(user: "",
                                                  password: "",
                                                  message: "Type your user and password",
                                                  isVisible: true)))
            }
            
        case .routeToSampleScreen:
            present(action: action, some: nil)
            
        case .routeToDismiss:
            present(action: action, some: nil)
            
        case .handle(user: let user, password: let password):
            
            guard !password.trim.isEmpty else {
                // 1 : Small bussiness validations (if needed)
                fwdStateToView(.loaded(.displayScreenBlockingMessage(value: "Invalid password", type: .warning)))
                return
            }
            
            // 2 : Display loading
            fwdStateToView(.loading(.init(isLoading: true, message: "loading".localized, id: "\(action)", devMessage: "\(action)")))

            // 3 : Make assync request
            sampleUseCase1
                .requestLoginWith(user: user, password: password)
                .sinkToReceiveValue({ (some) in
                    // 4 : Hide loading
                    fwdStateToView(.loading(.init(isLoading: false, message: "loading".localized, id: "\(action)", devMessage: "\(action)")))
                    switch some {
                    case .success(let response):
                        // 5 : All cool, present data
                        present(action: action, some: response)
                    case .failure(let error):
                        // 5 : Error! Present error
                        present(error: error, devMessage: "Fail on [\(action)] with error \(error)")
                    }
                })
                .store(in: cancelBag)
        }
    }
    
    /// To FWD states to the `View`, use`fwdStateToView`. Use for things related with View presenting data (view state)
    /// To FWD states to the `ViewController`, use `fwdStateToCoordinator`. Use for things related with navigation (Coordinator)
    func present(action: Action, some: Any?) {
        DevTools.Log.trace("[\(action)] with [\(String(describing: some))]", .viewModel)
        switch action {
        
        case .softReLoad:
            fwdStateToView(.softReLoad)
            
        case .viewLoaded:
            ()
            
        case .routeToSampleScreen:
            fwdStateToCoordinator(.sampleScreen(viewModelSetup: nil))
            
        case .routeToDismiss:
            #warning("Tutorial: V._xxx_ViewModel [fwdStateToCoordinator] vs [fwdStateToView]")
            fwdStateToCoordinator(.dismiss)
            
        case .handle(user: let user, _):
            if let model = some as? Model.Login {
                #warning("Tutorial: V._xxx_ViewModel [fwdStateToCoordinator] vs [fwdStateToView]")
                if !model.sucess {
                    // Fail on login! Display error...
                    fwdStateToView(.loaded(.nevesView(user: user,
                                                      password: "",
                                                      message: "Please try again latter \(user)!",
                                                      isVisible: true)))
                } else {
                    // On sucess, we dont do nothing, the navigation will be trigged by the view controller
                }
            } else {
                DevTools.assert(false, message: "Not predicted type [\(String(describing: some))] for [\(action)]")
            }
        }
    }
    
    func present(error: AppErrors, devMessage: String) {
        DevTools.Log.error(error, .viewModel)
        fwdStateToView(.loading(.init(isLoading: false, devMessage: devMessage)))
        var devMessageEscaped = devMessage
        if devMessageEscaped != "\(error.localisedForDevTeam!)" {
            devMessageEscaped = "\(devMessageEscaped) - \(error.localisedForDevTeam!)"
        }
        fwdStateToView(.error(error, devMessage: "\(devMessageEscaped)\n\nLocation: [\(Self.self)]"))
    }
}

//
// MARK: - Private
//

private extension VM.___VARIABLE_sceneName___ViewModel {
    func startObservingVehicleChangesRx() {
        
        // We can call `startObservingVehicleChangesRx` several times, so reset the bag to free the observers
        changesPublisherBag.cancel()
        
        /*
        // Observe changes at a particular field
        useCaseVehicleControl
            .requestCurrentVehicleChange(at: .carKeyStatus)
            .sinkToReceiveValue({ (some) in
                DevTools.Log.trace(some, .viewModel)
            })
            .store(in: changesPublisherBag)
        
        // Observe changes on every field (not recomended)
        useCaseVehicleControl
            .requestCurrentVehicleChanges()
            .sinkToReceiveValue({ (some) in
                DevTools.Log.trace(some, .viewModel)
            })
            .store(in: changesPublisherBag)
         */
    }
}

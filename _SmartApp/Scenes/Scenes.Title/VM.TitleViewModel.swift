//
//  VM.TitleViewModel.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 14/04/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
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
// VM.TitleViewModel files are used for:
//  - Responde to UIViewController events [func send(_ action: Action)]
//  - Handle bussiness responses and parse then to the ViewState [func present(action: Action, some: Any?)]
//  - Handle bussiness errors and parse then to the ViewState [func present(error: AppErrors)]
//
// Naming convention: Given a Scene named Title -> TitleViewModel
//

// MARK: - TitleViewModel

extension VM {
    
    //
    // ViewModel naming convention: Given a Scene named Title -> TitleViewModel
    //
    
    struct TitleViewModel: TitleViewModelProtocol,
                                              MVVMGenericViewModelProtocol {
        
        //
        // GenericViewModelProtocol
        //
        typealias ViewModelSetup = VM.Title.ViewModelInput.InitialSetup
        typealias Action         = VM.Title.ViewModelInput.Action
        typealias ViewData       = VM.Title.ViewInput.ViewData
        typealias CoordinatorActions = C.TitleCoordinator.Action
        
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

        #warning("Tutorial: ViewModel dependencies (MUST be resolved at DI.TitleAssembly) ")
        public var sampleUseCase1Protocol: SampleUseCase1Protocol!
        public var sampleUseCase2Protocol: SampleUseCase2Protocol!
    }
}

//
// MARK: - viewModelSetup : Computed values for UIViewController
//

extension VM.TitleViewModel {
    var name: String {
        viewModelSetup?.city ?? ""
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

extension VM.TitleViewModel {
    
    func send(_ action: Action) {

        DevTools.Log.trace(action, .viewModel)
        
        startObservingVehicleChangesRx()
                
        switch action {
        
        case .softReLoad:
            present(action: action, some: nil)
            
        case .viewLoaded:
            if let dataPassedFromPreviousVC = viewModelSetup {
                fwdStateToView(.loaded(.displayData(city: dataPassedFromPreviousVC.city, imageLight: dataPassedFromPreviousVC.imageLight, imageDark: dataPassedFromPreviousVC.imageDark)))
                //present(action: action, some: dataPassedFromPreviousVC.city)
            }
            
//            if let dataPassedFromPreviousVC = viewModelSetup {
//                // ViewModel received data to start with!
//                // 1 : Display Hello message
//                fwdStateToView(.loaded(.displayScreenBlockingMessage(value: "Hello \(dataPassedFromPreviousVC.city)",
//                                                                     type: .success)))
//
//                // 2 : Hide login component
//                fwdStateToView(.loaded(.nevesView(user: "",
//                                                  password: "",
//                                                  message: "",
//                                                  isVisible: false)))
//            } else {
//                fwdStateToView(.loaded(.nevesView(user: "",
//                                                  password: "",
//                                                  message: "Type your user and password",
//                                                  isVisible: true)))
//            }
            
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
            fwdStateToView(.loading(.init(isLoading: true, message: Lokalizable.loading2.localised, id: "", devMessage: "\(action)")))
            
            // 3 : Make assync request
            sampleUseCase1Protocol
                .requestLoginWith(user: user, password: password)
                .sinkToReceiveValue({ (some) in
                    // 4 : Hide loading
                    fwdStateToView(.loading(.init(isLoading: false, message: Lokalizable.loading2.localised, id: "", devMessage: "\(action)"))) 
                    switch some {
                    case .success(let response):
                        // 5 : All cool, present data
                        present(action: action, some: response)
                    case .failure(let error):
                        // 5 : Error! Present error
                        present(error: error, devMessage: "Error at [\(action)]")
                    }
                })
                .store(in: cancelBag)
        case .handleBtnOKTapped(postalcode: let postalcode):
            if let dataPassedFromPreviousVC = viewModelSetup {
                let trimmedDataPassed = dataPassedFromPreviousVC.postalCode.replacingOccurrences(of: " ", with: "")
                let trimmedPostalCode = postalcode.replacingOccurrences(of: " ", with: "")
                if trimmedDataPassed == postalcode || trimmedDataPassed == trimmedPostalCode {
                    fwdStateToView(.loaded(.displayMessage(message: "Yes")))
                } else {
                    fwdStateToView(.loaded(.displayMessage(message: "No\n" + "\(dataPassedFromPreviousVC.postalCode)")))
                }
            }
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
            fwdStateToCoordinator(.dismiss)
            
        case .handle(user: let user, _):
            if let model = some as? Model.Login {
                #warning("Tutorial: V._xxx_ViewModel [fwdStateToCoordinator] vs [fwdStateToView]")
                if model.sucess {
                    // Sucess on login! Route to next screen passing some data...
//                    Common_Utils.delay(1) { 
//                        fwdStateToCoordinator(.sampleScreen(viewModelSetup: .init(name: user)))
//                    }
                } else {
                    // Fail on login! Display error...
                    fwdStateToView(.loaded(.nevesView(user: user,
                                                      password: "",
                                                      message: "Please try again latter \(user)!",
                                                      isVisible: true)))
                }
            } else {
                DevTools.assert(false, message: "Not predicted type [\(String(describing: some))] for [\(action)]")
            }
        case .handleBtnOKTapped(postalcode: let postalcode):
            ()
        }
    }
    
    func present(error: AppErrors, devMessage: String) {
        DevTools.Log.error(error, .viewModel)
        fwdStateToView(.loading(.init(isLoading: false, devMessage: devMessage)))
        fwdStateToView(.error(error, devMessage: "[\(devMessage)] [\(error.localisedForDevTeam!)]\n\nLocation: [\(Self.self)]"))
    }
}

//
// MARK: - Private
//

private extension VM.TitleViewModel {
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

//
//  VM.ZipCodesListViewModel.swift
//  SmartApp
//
//  Created by Santos, Ricardo Patricio dos  on 06/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
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

//
// VM.ZipCodesListViewModel files are used for:
//  - Responde to UIViewController events [func send(_ action: Action)]
//  - Handle bussiness responses and parse then to the ViewState [func present(action: Action, some: Any?)]
//  - Handle bussiness errors and parse then to the ViewState [func present(error: AppErrors)]
//
// Naming convention: Given a Scene named ZipCodesList -> ZipCodesListViewModel
//

// MARK: - ZipCodesListViewModel

extension VM {
    
    //
    // ViewModel naming convention: Given a Scene named ZipCodesList -> ZipCodesListViewModel
    //
    
    struct ZipCodesListViewModel: ZipCodesListViewModelProtocol,
                                  MVVMGenericViewModelProtocol {
        
        //
        // GenericViewModelProtocol
        //
        typealias ViewModelSetup = VM.ZipCodesList.ViewModelInput.InitialSetup
        typealias Action         = VM.ZipCodesList.ViewModelInput.Action
        typealias ViewData       = VM.ZipCodesList.ViewInput.ViewData
        typealias CoordinatorActions = C.ZipCodesListCoordinator.Action
        
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
        
        //
        // Dependencies
        //
        public var sampleUseCase1: SampleUseCase1Protocol!
        public var sampleUseCase2: SampleUseCase2Protocol!
    }
}

//
// MARK: - viewModelSetup : Computed values for UIViewController
//

extension VM.ZipCodesListViewModel {
    var name: String {
        self.viewModelSetup?.name ?? ""
    }
}

//
// MARK: - GenericViewModelProtocol functions
//

/**
 * Function `func send(_ action: Action)`: Receives action for the View (View->ViewController->ViewModel), and do something (assync request, routing, etc).
 * Function `func send(_ action: Action)` call `func present(action: Action, some: Any?)` with the response received.
 * Function `func present(action: Action, some: Any?)`, receives something sent from `func send(_ action: Action)` and parses it on a way that the view can read it.
 * Function `func present(error: AppErrors)` handle and fwd errors to the view.
 */

extension VM.ZipCodesListViewModel {
    
    func send(_ action: Action) {
        
        DevTools.Log.trace(action, .viewModel)
        
        startObservingVehicleChangesRx()
        
        switch action {
            
        case .softReLoad:
            present(action: action, some: nil)
            
        case .viewLoaded:
            sampleUseCase1.requestZipCodesWhereStored()
                .sinkToReceiveValue({ (some) in
                    switch some {
                    case .success(let response):
                        present(action: action, some: response)
                        send(.fetchRecords(filter: "", delay: true, displayLoading: false))
                    case .failure(let error):
                        present(error: error, devMessage: "Fail on [\(action)] with error \(error)")
                    }
                })
                .store(in: cancelBag)
            
        case .fetchRecords(filter: let filter, delay: let delay, displayLoading: let displayLoading):
                      
            if displayLoading {
                // Display loading
                fwdStateToView(.loading(.init(isLoading: true,
                                              message: "loading".localized,
                                              id: "\(action)",
                                              devMessage: "\(action)")))
            }
            // 2 : Make assync request
            Just(1)
                .setFailureType(to: AppErrors.self)
                .eraseToAnyPublisher()
                .delay(seconds: delay ? 0.5 : 0.1)
                .flatMap { _ in sampleUseCase1.requestZipCodes(filter: filter) }
                .sinkToReceiveValue({ (some) in
                    // 3 : Hide loading
                    fwdStateToView(.loading(.init(isLoading: false, id: "\(action)", devMessage: "\(action)")))
                    switch some {
                    case .success(let response):
                        // 4 : All cool, present data
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
            if let zipCodesWhereStored = some as? Bool {
                if !zipCodesWhereStored {
                    let message = "Loading records for the first time.\n\nWill take some seconds (to download and store)..."
                    fwdStateToView(.loading(.init(isLoading: true, message: message, id: "\(action)", devMessage: "\(action)")))
                } else {
                    fwdStateToView(.loading(.init(isLoading: true, message: "loading".localized, id: "\(action)", devMessage: "\(action)")))
                }
            } else {
                DevTools.assert(false, message: "Not predicted type [\(String(describing: some))] for [\(action)]")
            }
            
        case .fetchRecords:
            if let model = some as? [Model.PortugueseZipCode] {
                let items: [VM.ZipCodesListHolder.TableItem] = model.map {
                    if $0.desigPostal == $0.nomeLocalidade.uppercased() {
                        
                        let value = $0.desigPostal.lowercased() + " : " + $0.numCodPostal + " - " + $0.extCodPostal
                        return VM.ZipCodesListHolder.TableItem(title: $0.nomeLocalidade.lowercased(),
                                                               value: value,
                                                               id: $0.id)
                    } else {
                        let value = $0.desigPostal + " : " + $0.numCodPostal + " - " + $0.extCodPostal
                        return VM.ZipCodesListHolder.TableItem(title: $0.nomeLocalidade.uppercased(),
                                                               value: value,
                                                               id: $0.id)
                    }
                   
                }
                let maxItems = 100
                if items.count > maxItems {
                    let itemsPrefix = Array(items.prefix(maxItems))
                    fwdStateToView(.loaded(.display(title: "\(items.count) records (top \(maxItems))", items: itemsPrefix)))
                } else {
                    fwdStateToView(.loaded(.display(title: "\(items.count) records", items: items)))
                }

            } else {
                DevTools.assert(false, message: "Not predicted type [\(String(describing: some))] for [\(action)]")
            }
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

private extension VM.ZipCodesListViewModel {
    func startObservingVehicleChangesRx() {
        
        // We can call `startObservingVehicleChangesRx` several times, so reset the bag to free the observers
        changesPublisherBag.cancel()
        
    }
}

//
// MARK: - Private Presentation Logic
//

private extension VM.ZipCodesListViewModel {
    
    // For more complex data to handle before send to view, we can create private custom presenter functions.
    // Presentation logic should be at ViewModel file end, inside `MARK: - Private Presentation Logic`
    
}

//
//  VM.MoviesViewModel.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 09/06/2022.
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
// VM.MoviesViewModel files are used for:
//  - Responde to UIViewController events [func send(_ action: Action)]
//  - Handle bussiness responses and parse then to the ViewState [func present(action: Action, some: Any?)]
//  - Handle bussiness errors and parse then to the ViewState [func present(error: AppErrors)]
//
// Naming convention: Given a Scene named Movies -> MoviesViewModel
//

// MARK: - MoviesViewModel

extension VM {
    
    //
    // ViewModel naming convention: Given a Scene named Movies -> MoviesViewModel
    //
    
    struct MoviesViewModel: MoviesViewModelProtocol,
                                              MVVMGenericViewModelProtocol {
        
        //
        // GenericViewModelProtocol
        //
        typealias ViewModelSetup = VM.Movies.ViewModelInput.InitialSetup
        typealias Action         = VM.Movies.ViewModelInput.Action
        typealias ViewData       = VM.Movies.ViewInput.ViewData
        typealias CoordinatorActions = C.MoviesCoordinator.Action
        
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

        #warning("Tutorial: ViewModel dependencies (MUST be resolved at DI.MoviesAssembly) ")
        public var sampleUseCase1Protocol: SampleUseCase1Protocol!
        public var sampleUseCase2Protocol: SampleUseCase2Protocol!
    }
}

//
// MARK: - viewModelSetup : Computed values for UIViewController
//

extension VM.MoviesViewModel {
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

extension VM.MoviesViewModel {
    
    func send(_ action: Action) {

        DevTools.Log.trace(action, .viewModel)
        
        startObservingVehicleChangesRx()
                
        switch action {
        
        case .softReLoad:
            present(action: action, some: nil)
            
        case .viewLoaded:
            //send(.configureRows(indexPath: IndexPath, delay: false, displayLoading: false, cell: nil))
            if let dataPassedFromPreviousVC = viewModelSetup {
                // ViewModel received data to start with!
                // 1 : Display Hello message
//                fwdStateToView(.loaded(.displayScreenBlockingMessage(value: "Hello \(dataPassedFromPreviousVC.name)",
//                                                                     type: .success)))
//
//                // 2 : Hide login component
//                fwdStateToView(.loaded(.nevesView(user: "",
//                                                  password: "",
//                                                  message: "",
//                                                  isVisible: false)))
            } else {
//                fwdStateToView(.loaded(.nevesView(user: "",
//                                                  password: "",
//                                                  message: "Type your user and password",
//                                                  isVisible: true)))
            }
            
        case .routeToSampleScreen:
            present(action: action, some: nil)
            
        case .routeToDismiss:
            present(action: action, some: nil)
            
        case .handle(user: let user, password: let password):
            
            guard !password.trim.isEmpty else {
                // 1 : Small bussiness validations (if needed)
//                fwdStateToView(.loaded(.displayScreenBlockingMessage(value: "Invalid password", type: .warning)))
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
        case .configureRows(indexPath: let indexPath, delay: let delay, displayLoading: let displayLoading, cell: let cell):
            if displayLoading {
                // Display loading
                fwdStateToView(.loading(.init(isLoading: true,
                                              message: "loading".localized,
                                              id: "\(action)",
                                              devMessage: "\(action)")))
            }
            switch indexPath.section {
            case VM.Movies.Sections.mostPopular.rawValue:
                APICaller.shared.getMostPopularMovies { [self] result in
                    configureCells(result: result, cell: cell)
                }
            case VM.Movies.Sections.top250Movies.rawValue:
                APICaller.shared.getTop250Movies { [self] result in
                    configureCells(result: result, cell: cell)
                }
            case VM.Movies.Sections.inTheaters.rawValue:
                APICaller.shared.getInTheaters { [self] result in
                    configureCells(result: result, cell: cell)
                }
            case VM.Movies.Sections.commingSoon.rawValue:
                APICaller.shared.getCommingSoonMovies { [self] result in
                    configureCells(result: result, cell: cell)
                }
            default:
                break
            }
        case .cellPressed(cell: let cell, viewModel: let viewModel):
            present(action: action, some: viewModel)
        case .getSearchResults(value: let value):
            present(action: action, some: value)
        case .handleItemPressed(indexPath: let indexPath, movies: let movies):
            present(action: action, some: movies)
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
                    Common_Utils.delay(1) { 
                        fwdStateToCoordinator(.sampleScreen(viewModelSetup: .init(name: user)))
                    }
                } else {
                    // Fail on login! Display error...
//                    fwdStateToView(.loaded(.nevesView(user: user,
//                                                      password: "",
//                                                      message: "Please try again latter \(user)!",
//                                                      isVisible: true)))
                }
            } else {
                DevTools.assert(false, message: "Not predicted type [\(String(describing: some))] for [\(action)]")
            }
        case .configureRows(indexPath: let indexPath, delay: let delay, displayLoading: let displayLoading, cell: let cell):
            ()
        case .cellPressed(cell: let cell, viewModel: let viewModel):
            fwdStateToCoordinator(.cellPressedNewScreen(viewModelSetup: .init(viewModel: viewModel)))
        case .getSearchResults(value: let value):
            APICaller.shared.searchMovie(with: value) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        fwdStateToView(.loaded(.displayResults(movies: movies)))
                    case .failure:
                        fwdStateToView(.loaded(.noResults))
                    }
                }
            }
        case .handleItemPressed(indexPath: let indexPath, movies: let movies):
            let moviesInfo = movies[indexPath.row]
            guard let movieName = moviesInfo.fullTitle ?? moviesInfo.title,
                    let movieImage = moviesInfo.image ?? moviesInfo.image,
                    let movieDescription = moviesInfo.description ?? Optional(""),
                    let movieActors = moviesInfo.crew ?? moviesInfo.stars ?? Optional("")
            else {
                return
            }
            let viewModel = Model.MovieDetail(fullTitle: movieName,
                                        title: movieName,
                                        imageView: movieImage,
                                        description: movieDescription,
                                        imDbRating: "",
                                        metacriticRating: "",
                                        actors: movieActors )
            fwdStateToCoordinator(.cellPressedNewScreen(viewModelSetup: .init(viewModel: viewModel)))
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

private extension VM.MoviesViewModel {
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

private extension VM.MoviesViewModel {
    func configureCells(result: Result<[Model.Movie], Error>, cell: V.TableViewCell) {
        switch result {
        case .success( let moviesInfo ):
                cell.configure(with: moviesInfo)
        case .failure:
            break
        }
    }
}

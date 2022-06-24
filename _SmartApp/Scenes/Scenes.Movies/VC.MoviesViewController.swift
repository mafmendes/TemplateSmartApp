//
//  VC.MoviesViewController.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 09/06/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
import Combine
import SwiftUI
//
import Common
import BaseUI
import BaseDomain
import DevTools
import Resources
import AppConstants

#warning("Tutorial: VC.ViewController files ->")

//
// VC.MoviesViewController files are used for:
//  - Received view [var genericView: T!] events and forward then into the viewModel
//  - Iniciate navigation using [var coordinator: MoviesCoordinatorProtocol!]
//
// Naming convention: Given a Scene named Movies -> MoviesViewController
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PMoviesVCPreviews: PreviewProvider {
    static var previews: some View {
        Common_ViewControllerRepresentable {
            let vc = VC.MoviesViewController.instance()!
            vc.doViewWillFirstAppear()
            return vc
        }
        .buildPreviews(full: false)
    }
}

#endif

extension VC {
    
    //
    // ViewController naming convention: Given a Scene named Movies -> MoviesViewController
    //
    
    public class MoviesViewController: BaseGenericViewController<V.MoviesView>,
                                                         MoviesViewControllerProtocol,
                                                         GenericViewControllerProtocol,
                                                         MVVMGenericViewControllerProtocol {

        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }
        
        var viewModel: VM.MoviesViewModel?
        var viewModelSetup: VM.Movies.ViewModelInput.InitialSetup?
        var coordinatorActions = GenericObservableObjectForHashable<C.MoviesCoordinator.Action>()
        var coordinator: MoviesCoordinatorProtocol!
        
//        public override func vipSetup() {
//            // This function is called automatically by super BaseGenericView
//        }
        
        //
        // MARK: View lifecycle
        //
        
        public override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        }
        
        public override func viewWillFirstAppear() {
            genericView.viewWillFirstAppear()
            viewModel?.send(.viewLoaded)
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            genericView.viewWillAppear()
        }
        
        public override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            genericView.viewDidAppear()
        }
        
        //
        // MARK: Mandatory methods
        //
        
        // This function is called automatically by super BaseGenericView
        public override func rxSetup() {
            
            // Fwd to Coordinator
            coordinatorActions.value.sink { [weak self] (result) in
                #warning("Tutorial: ViewController bridge place from ViewModel to Coordinator")
                guard let self = self else { return }
                DevTools.Log.trace(result, .viewController)
                self.coordinator.perform(result)
            }.store(in: cancelBag)
            
            // Fwd to ViewModel
            genericView.output.value.sink { [weak self] (result) in
                #warning("Tutorial: ViewController bridge place from View to ViewModel")
                guard let self = self else { return }
                switch result {
                case .btnDismissTapped:
                    self.viewModel?.send(.routeToDismiss)
                case .userTyped(user: let user, password: let password):
                    self.viewModel?.send(.handle(user: user, password: password))
                case .configureRows(indexPath: let indexPath, delay: let delay, displayLoading: let displayLoading, cell: let cell):
                    self.viewModel?.send(.configureRows(indexPath: indexPath, delay: delay, displayLoading: displayLoading, cell: cell))
                case .cellPressed(cell: let cell, viewModel: let viewModel):
                    self.viewModel?.send(.cellPressed(cell: cell, viewModel: viewModel))
                case .search(value: let value):
                    self.viewModel?.send(.getSearchResults(value: value))
                case .itemPressed(indexPath: let indexPath, movies: let movies):
                    self.viewModel?.send(.handleItemPressed(indexPath: indexPath, movies: movies))
                }
            }.store(in: cancelBag)
        }
            
        // We can setup themes/colors/layouts here (on UIViewController), but we shouldnt. Should be done on GenericView...
        // This function is called automatically by super BaseGenericView
        public override func setupColorsAndStyles() { }
        
        // We can setup themes/colors/layouts here (on UIViewController), but we shouldnt. Should be done on GenericView...
        // This function is called automatically by super BaseGenericView
        public override func prepareLayoutByFinishingPrepareLayout() { }

        // We can setup themes/colors/layouts here (on UIViewController), but we shouldnt. Should be done on GenericView...
        // This function is called automatically by super BaseGenericView
        public override func prepareLayoutBySettingAutoLayoutsRules() { }
        
        // We can setup themes/colors/layouts here (on UIViewController), but we shouldnt. Should be done on GenericView...
        // This function is called automatically by super BaseGenericView
        public override func prepareLayoutCreateHierarchy() { }

        // We can setup themes/colors/layouts here (on UIViewController), but we shouldnt. Should be done on GenericView...
        // This function is called automatically by super BaseGenericView
        public override func setupViewIfNeed() { }

        // This function is called automatically by super BaseGenericView
        public override func setupNavigationUIRx() {
            setupTitleView()
        }
        
        private func setupTitleView() {
            guard let navigationController = navigationController else {
                return
            }
            navigationController.navigationBar.isHidden = true
        }
        
        open override func displayLoading(viewModel: BaseDisplayLogicModels.Loading) {
            if viewModel.isLoading {
                V.LoadingView.presentOver(self, message: viewModel.message, id: viewModel.id)
            } else {
                V.LoadingView.dismiss(from: self)
            }
        }
    }
}

//
// MARK: TabBarRootViewControllerProtocol
//

extension VC.MoviesViewController: TabBarRootViewControllerProtocol {
    public func performSoftReLoad(_ completion:() -> Void) {
        coordinator.perform(.softReLoad)
        Common_Utils.delay(TimeIntervals.defaultAnimationDuration) { [weak self] in
            self?.viewModel?.send(.softReLoad)
        }
    }
    
    public func performHardReLoad(_ completion:() -> Void) {
        performSoftReLoad { [weak self] in
            self?.viewModel?.send(.viewLoaded)
        }
    }
}

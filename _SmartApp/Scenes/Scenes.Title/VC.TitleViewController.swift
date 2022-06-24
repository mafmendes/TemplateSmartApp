//
//  VC.TitleViewController.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 14/04/2022.
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
// VC.TitleViewController files are used for:
//  - Received view [var genericView: T!] events and forward then into the viewModel
//  - Iniciate navigation using [var coordinator: TitleCoordinatorProtocol!]
//
// Naming convention: Given a Scene named Title -> TitleViewController
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PTitleVCPreviews: PreviewProvider {
    static var previews: some View {
        Common_ViewControllerRepresentable {
            let vc = VC.TitleViewController.instance()!
            vc.doViewWillFirstAppear()
            return vc
        }
        .buildPreviews(full: false)
    }
}

#endif

extension VC {
    
    //
    // ViewController naming convention: Given a Scene named Title -> TitleViewController
    //
    
    public class TitleViewController: BaseGenericViewController<V.TitleView>,
                                                         TitleViewControllerProtocol,
                                                         GenericViewControllerProtocol,
                                                         MVVMGenericViewControllerProtocol {

        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }
        
        var viewModel: VM.TitleViewModel?
        var viewModelSetup: VM.Title.ViewModelInput.InitialSetup?
        var coordinatorActions = GenericObservableObjectForHashable<C.TitleCoordinator.Action>()
        var coordinator: TitleCoordinatorProtocol!
        
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
                case .btnOKTapped(postalcode: let postalcode):
                    self.viewModel?.send(.handleBtnOKTapped(postalcode: postalcode))
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

extension VC.TitleViewController: TabBarRootViewControllerProtocol {
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

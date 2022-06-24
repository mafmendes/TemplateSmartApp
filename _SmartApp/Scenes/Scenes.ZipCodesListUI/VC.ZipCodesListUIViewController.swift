//
//  VC.ZipCodesListUIViewController.swift
//  SmartApp
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

//
// VC.ZipCodesListUIViewController files are used for:
//  - Received view [var genericView: T!] events and forward then into the viewModel
//  - Iniciate navigation using [var coordenator: ZipCodesListUICoordinatorProtocol!]
//
// Naming convention: Given a Scene named ZipCodesListUI -> ZipCodesListUIViewController
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PZipCodesListUIVCPreviews: PreviewProvider {
    static var previews: some View {
        Common_ViewControllerRepresentable {
            let vc = VC.ZipCodesListUIViewController.instance(with: nil)!
            vc.doViewWillFirstAppear()
            return vc
        }
        .buildPreviews(full: false)
    }
}

#endif

extension VC {
    
    //
    // ViewController naming convention: Given a Scene named ZipCodesListUI -> ZipCodesListUIViewController
    //
    
    public class ZipCodesListUIViewController: BaseGenericViewController<V.ZipCodesListUIView>,
                                                         ZipCodesListUIViewControllerProtocol,
                                                         GenericViewControllerProtocol,
                                                         MVVMGenericViewControllerProtocol {

        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }
        
        var viewModel: VM.ZipCodesListUIViewModel?
        var viewModelSetup: VM.ZipCodesListUI.ViewModelInput.InitialSetup?
        var coordinatorActions = GenericObservableObjectForHashable<C.ZipCodesListUICoordinator.Action>()
        var coordenator: ZipCodesListUICoordinatorProtocol!
                
        //
        // MARK: View lifecycle
        //
        
        public override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
        }
        
        public override func viewWillFirstAppear() {
            viewModel?.send(.viewLoaded)
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        
        //
        // MARK: Dark Mode
        //
        
        public override func setupColorsAndStyles() {
            //
            // We can setup themes here (on UIViewController), but we shouldnt...
            //
            setupTitleView()
        }
        
        //
        // MARK: Mandatory methods
        //
        
        // This function is called automatically by super BaseGenericView
        public override func rxSetup() {
            
            // Fwd to Coordenator
            coordinatorActions.value.sink { [weak self] (result) in
                guard let self = self else { return }
                DevTools.Log.trace(result, .viewController)
                switch result {
                case .softReLoad: self.coordenator.perform(.dismiss)
                case .dismiss: self.coordenator.perform(.dismiss)
                case .sampleScreen(viewModelSetup: let viewModelSetup):
                    self.coordenator.perform(.sampleScreen(viewModelSetup: viewModelSetup))
                case .newScreen(viewSetup: let viewSetup):
                    self.coordenator.perform(.newScreen(viewSetup: viewSetup))
                }
            }.store(in: cancelBag)
            
            // Fwd to ViewModel
            genericView.output.value.sink { [weak self] (some) in
                guard let self = self else { return }
                switch some {
                case .search(value: let value):
                    self.viewModel?.send(.fetchRecords(filter: value, delay: false, displayLoading: true))
                case .cellSelected(cell: let cell):
                    self.viewModel?.send(.display(title: cell.title))
                case .routeToNewScreen(city: let title, imageDark: let imageD, imageLight: let imageL, postalcode: let pc):
                    self.viewModel?.send(.routeToNewScreen(title: title, imageLight: imageL, imageDark: imageD, postalcode: pc))
                }
            }.store(in: cancelBag)
        }
                
        // This function is called automatically by super BaseGenericView
        public override func prepareLayoutByFinishingPrepareLayout() { }

        // This function is called automatically by super BaseGenericView
        public override func prepareLayoutBySettingAutoLayoutsRules() { }
        
        // This function is called automatically by super BaseGenericView
        public override func prepareLayoutCreateHierarchy() { }

        // This function is called automatically by super BaseGenericView
        public override func setupViewIfNeed() { }

        // This function is called automatically by super BaseGenericView
        public override func setupNavigationUIRx() {
            setupTitleView()
        }
        
        open override func displayLoading(viewModel: BaseDisplayLogicModels.Loading) {
            if viewModel.isLoading {
                V.LoadingView.presentOver(self, message: viewModel.message, id: viewModel.id)
            } else {
                V.LoadingView.dismiss(from: self)
            }
        }
        
        private func setupTitleView() {
            guard let navigationController = navigationController else {
                return
            }
            navigationController.navigationBar.isHidden = false
        }
        
    }
}

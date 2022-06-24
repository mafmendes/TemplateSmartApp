//
//  V.ZipCodesListView.swift
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
import DevTools
import BaseDomain
import AppDomain
import BaseUI
import Designables
import Resources
import AppConstants

//
// V.ZipCodesListView files are used for:
//  - Build the UI
//  - Expose to the UIViewController (via Combine and on extension on file end) the user interactor events
//
// Naming convention: Given a Scene named ZipCodesList -> ZipCodesListView
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PZipCodesListVPreviews: PreviewProvider {
    static var previews: some View {
        PZipCodesListVCPreviews.previews
    }
}
#endif

extension V {

    public class ZipCodesListView: BaseGenericView,
                                               ZipCodesListViewProtocol,
                                               GenericViewProtocol,
                                               MVVMGenericViewProtocol {
        
        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }

        public typealias ViewData = VM.ZipCodesList.ViewInput.ViewData
        public typealias ViewOutput = VM.ZipCodesList.ViewOutput.Action
        public var output = GenericObservableObjectForHashable<ViewOutput>()
        public var input = MVVMViewInputObservable<ViewData>()
        
        //
        // MARK: - UI Elements (Private and lazy by default)
        //
        private var backgroundGradient: CAGradientLayer?
        
        private lazy var searchField: UISearchTextField = {
            UISearchTextField()
        }()
        
        private lazy var zipCodesListHolder: (container: UIView, compoment: V.ZipCodesListHolder) = {
            let compoment = V.ZipCodesListHolder(input: .init(title: "", items: []))
            return (compoment.uiView, compoment)
        }()
        
        //
        // MARK: - View Life Cicle : Mandatory
        //
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        public override func prepareLayoutCreateHierarchy() {
            addSubview(searchField)
            addSubview(zipCodesListHolder.container)
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            searchField.layouts.topToSuperview(offset: 0, usingSafeArea: true)
            searchField.layouts.leadingToSuperview(offset: SizeNames.defaultMargin)
            searchField.layouts.trailingToSuperview(offset: SizeNames.defaultMargin)
            searchField.layouts.height(SizeNames.defaultMargin * 2)
            
            zipCodesListHolder.container.layouts.topToBottom(of: searchField, offset: SizeNames.defaultMargin)
            zipCodesListHolder.container.layouts.leadingToSuperview(offset: 0)
            zipCodesListHolder.container.layouts.trailingToSuperview(offset: 0)
            zipCodesListHolder.container.layouts.bottomToSuperview()
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        public override func prepareLayoutByFinishingPrepareLayout() {
            zipCodesListHolder.container.alpha = 0.8
        }
        
        public override func setupColorsAndStyles() {
            backgroundGradient = installGradientBackground(backgroundGradient: backgroundGradient)
            backgroundColor = ColorSemantic.backgroundPrimary.uiColor
        }
        
        // This function is called automatically by super BaseGenericView
        // All reactive behaviours should be inside this function
        public override func setupViewUIRx() {
            
            // Handle View inputs and to view screen
            input.value.sink { [weak self] (state) in
                guard let self = self else { return }
                self.handle(stateInput: state)
            }.store(in: cancelBag)
            
            searchField.editingChangedPublisher.sinkToReceiveValue { [weak self] (some) in
                guard let self = self else { return }
                if let toSearch = some.sucessUnWrappedValue as? String {
                    self.fwdStateToViewController(.search(value: toSearch))
                }
            }.store(in: cancelBag)
            
            //check for press on element of list of zipcodes
            zipCodesListHolder.compoment.output.value.sink { [weak self] (result) in
                guard let self = self else { return }
                DevTools.Log.trace(result, .view)
                switch result {
                case .itemPressed(id: let id):
                   //continuar depois isto
                    break
                }
            }.store(in: cancelBag)
        
        }
    }
}

//
// MARK: - setupWith(viewModel: ViewData)
// This section is mandatory for all (Scene) Views, and is were we andle data sent by the ViewController/ViewModel

extension V.ZipCodesListView {

    /// Use to put the screen/view on his initial state, (not necessaring reload all the data)
    func softReLoad() {
        
    }
    
    func handle(stateInput: MVVMViewInput<ViewData>) {
        DevTools.Log.trace(stateInput, .view)
        guard let viewController = asView.common.viewController else { return }
        guard let baseViewController = viewController as? BaseViewController else { return }
        Common_Utils.executeInMainTread { [weak baseViewController] in
            switch stateInput {
            case .loading(model: let model): baseViewController?.displayLoading(viewModel: model)
            case .loaded(let model): self.setupWith(viewModel: model)
            case .error(let error, let devMessage):
                var message = "\(Message.pleaseTryAgainLater.localised)\n\n\(error.localizedDescription)"
                if let error = error as? AppErrors, let messageForUI = error.localisedForUser {
                    message = messageForUI
                }
                baseViewController?.displayError(viewModel: .init(title: "",
                                                                  message: message,
                                                                  devMessage: "\(devMessage)"))
            case .softReLoad: self.softReLoad()
            }
        }
    }

    /// Where to handle the ViewData sent by the ViewModel/ViewController and display it on the view
    func setupWith(viewModel: ViewData) {
        switch viewModel {
        case .display(title: let title, items: let items):
            zipCodesListHolder.compoment.input.title = title
            zipCodesListHolder.compoment.input.items = items
        }
    }
}

//
// MARK: - Events Simulation (testing)
// All functions used on UnitTests must start with simulate
//

extension V.ZipCodesListView {
    
}

//
// MARK: - Private
// All (Scene) Views should have a private section with auxiliar functions
//

private extension V.ZipCodesListView {
    func handleMessage(_ message: String) {
        if !message.trim.isEmpty {
            displayMessage(title: "", message, type: .warning, actions: [])
        }
    }
}

//
// MARK: - Events capture (Sugar for View ONLY)
//

private extension V.ZipCodesListView {

}

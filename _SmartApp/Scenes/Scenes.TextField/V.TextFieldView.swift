//
//  V.TextFieldView.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 11/04/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
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

#warning("Tutorial: V._xxx_View files ->")

//
// V.TextFieldView files are used for:
//  - Build the UI
//  - Expose to the UIViewController (via Combine and on extension on file end) the user interactor events
//
// Naming convention: Given a Scene named TextField -> TextFieldView
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PTextFieldVPreviews: PreviewProvider {
    static var previews: some View {
        // Common_ViewRepresentable(V.TextFieldView())
        Common_ViewRepresentable { V.TextFieldView() }.buildPreviews()
    }
}
#endif

extension V {

    public class TextFieldView: BaseGenericView,
                                               GenericViewProtocol,
                                MVVMGenericViewProtocol {

        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }

        public typealias ViewData = VM.TextField.ViewInput.ViewData
        public typealias ViewOutput = VM.TextField.ViewOutput.Action
        public var output = GenericObservableObjectForHashable<ViewOutput>()
        public var input = MVVMViewInputObservable<ViewData>()
        
        //
        // MARK: - UI Elements (Private and lazy by default)
        //
        
        private var backgroundGradient: CAGradientLayer?

        #warning("Tutorial: UI elements are ussually [private] AND [lazy]")
        private lazy var nevesView: (container: UIView, compoment: NevesView) = {
            #warning("Tutorial: (container: UIView, compoment: NevesView)")
            /**
            We wrap SwiftUI components into 2 parts :
            1 : `component` that is the SwiftUI View as it is and is used to interact with the component
            2 :  `container`that is a UIKit wrapper arround our component and that we use to adjust the constraints on the app screen*/
            let compoment = NevesView(input: .init(userName: "", password: ""))
            return (compoment.uiView, compoment)
        }()
        
        private lazy var btnDismiss: UIButton = {
            UIFactory.button(title: Message.dismiss.localised, style: .primary)
        }()
        
        private lazy var textField: UITextField = {
            UIFactory.uiTextField()
        }()
        
        private lazy var btnConfirm: UIButton = {
            UIFactory.button(title: Message.ok.localised, style: .primary)
        }()
        
        private lazy var lblInfo: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        
        //
        // MARK: - View Life Cicle : Mandatory
        //
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        public override func prepareLayoutCreateHierarchy() {
            addSubview(nevesView.container)
            //addSubview(btnDismiss)
            addSubview(textField)
            addSubview(btnConfirm)
            addSubview(lblInfo)
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
            nevesView.container.layouts.topToSuperview(offset: SizeNames.defaultMargin * 3)
            nevesView.container.layouts.leadingToSuperview(offset: VM.TextField.Constants.screenHorizontalMargin)
            nevesView.container.layouts.trailingToSuperview(offset: VM.TextField.Constants.screenHorizontalMargin)

//            btnDismiss.layouts.topToBottom(of: nevesView.container, offset: SizeNames.defaultMargin)
//            btnDismiss.layouts.size(VM.TextField.Sizes.btnDismissSize)
//            btnDismiss.layouts.centerXToSuperview()

            textField.layouts.topToBottom(of: nevesView.container, offset: SizeNames.defaultMargin)
            textField.layouts.leading(to: nevesView.container)
            textField.layouts.trailing(to: nevesView.container)
            
            btnConfirm.layouts.topToBottom(of: textField, offset: SizeNames.defaultMargin)
            btnConfirm.layouts.size(VM.TextField.Sizes.btnDismissSize)
            btnConfirm.layouts.centerXToSuperview()
            
            lblInfo.layouts.topToBottom(of: btnConfirm, offset: SizeNames.defaultMargin)
            lblInfo.layouts.centerXToSuperview()
            lblInfo.layouts.leadingToSuperview(offset: VM.TextField.Constants.screenHorizontalMargin)
            lblInfo.layouts.trailingToSuperview(offset: VM.TextField.Constants.screenHorizontalMargin)

        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        public override func prepareLayoutByFinishingPrepareLayout() {
            //btnDismiss.setTitleForAllStates("Dismiss")
            btnConfirm.setTitleForAllStates("OK")
            lblInfo.numberOfLines = 0
            lblInfo.text = """
                New Text to be added
                """
            installDevViewOn(view: asView)
        }
        
        public override func setupColorsAndStyles() {
            backgroundGradient = installGradientBackground(backgroundGradient: backgroundGradient)
            backgroundColor = ColorSemantic.backgroundPrimary.uiColor
            textField.addBorder(width: 2, color: UIColor.black, animated: true)
            lblInfo.applyStyle(.footnote, .labelSecondary)
        }
        
        // This function is called automatically by super BaseGenericView
        // All reactive behaviours should be inside this function
        public override func setupViewUIRx() {

            // Handle View inputs and to view screen
            input.value.sink { [weak self] (state) in
                guard let self = self else { return }
                self.handle(stateInput: state)
            }.store(in: cancelBag)
            
            // Fwd to ViewController
            nevesView.compoment.output.value.sink { [weak self] (result) in
                guard let self = self else { return }
                DevTools.Log.trace(result, .view)
                switch result {
                case .btnPressed(date: _, userName: let userName, password: let password):
                    self.fwdStateToViewController(.userTyped(user: userName, password: password))
                }
            }.store(in: cancelBag)
            
            // Fwd to ViewController
            btnDismiss.combine.touchUpInsidePublisher.sink { [weak self] (_) in
                guard let self = self else { return }
                self.fwdStateToViewController(.btnDismissTapped)
            }.store(in: cancelBag)
            
            btnConfirm.combine.touchUpInsidePublisher.sink { [weak self] (_) in
                guard let self = self else { return }
                self.fwdStateToViewController(.btnConfirmTapped(newText: self.textField.text!))
            }.store(in: cancelBag)
            
        }
    }
}

//
// MARK: - TextFieldViewProtocol
//

extension V.TextFieldView: TextFieldViewProtocol {
    
    func viewWillAppear() {
        // Will be called by the ViewContoller (remember this class is View)
    }
    
    func viewWillFirstAppear() {
        // Will be called by the ViewContoller (remember this class is View)
    }
    
    func viewDidAppear() {
        // Will be called by the ViewContoller (remember this class is View)
    }
}
    
//
// MARK: - setupWith(viewModel: ViewData)
// This section is mandatory for all (Scene) Views, and is were we andle data sent by the ViewController/ViewModel
//

extension V.TextFieldView {

    /// Use to put the screen/view on his initial state, (not necessaring reload all the data)
    func softReLoad() {
        
    }
    
    #warning("Tutorial: The place were our View receives the Actions from the ViewModel")
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

    #warning("Tutorial: Helper for [func handle(stateInput: MVVMViewInput<ViewData>)] were we hangle the [loaded] case")
    /// Where to handle the ViewData sent by the ViewModel/ViewController and display it on the view
    func setupWith(viewModel: ViewData) {
        switch viewModel {
        
        case .displayScreenBlockingMessage(value: let value, type: let type):
            displayMessage(title: "", value, type: type, actions: [])
            
        case .nevesView(user: let user,
                        password: let password,
                        message: let message,
                        isVisible: let isVisible):
            nevesView.container.fadeTo(isVisible ? 1 : 0)
            nevesView.compoment.input.message = message
            nevesView.compoment.input.userName = user
            nevesView.compoment.input.password = password
            
        case .displayNewLabel(label: let newLabel):
            lblInfo.text = newLabel
        }
        
    }
}

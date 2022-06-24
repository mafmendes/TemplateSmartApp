//
//  V.TitleView.swift
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
import DevTools
import BaseDomain
import AppDomain
import BaseUI
import Designables
import Resources
import AppConstants

#warning("Tutorial: V._xxx_View files ->")

//
// V.TitleView files are used for:
//  - Build the UI
//  - Expose to the UIViewController (via Combine and on extension on file end) the user interactor events
//
// Naming convention: Given a Scene named Title -> TitleView
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PTitleVPreviews: PreviewProvider {
    static var previews: some View {
        // Common_ViewRepresentable(V.TitleView())
        Common_ViewRepresentable { V.TitleView() }.buildPreviews()
    }
}
#endif

extension V {

    public class TitleView: BaseGenericView,
                                               GenericViewProtocol,
                                               MVVMGenericViewProtocol {

        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }

        public typealias ViewData = VM.Title.ViewInput.ViewData
        public typealias ViewOutput = VM.Title.ViewOutput.Action
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
        
        private lazy var btnOK: UIButton = {
            UIFactory.button(title: Message.dismiss.localised, style: .primary)
        }()
        
        private lazy var lblInfo: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        
        private lazy var lblPostalCode: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        
        private lazy var lblTitle: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        
        private lazy var txtField: UITextField = {
            UIFactory.uiTextField()
        }()
        
        private lazy var image: UIImageView = {
            UIFactory.imageView()
        }()
    
        private lazy var imageLight: UIImageView = {
            UIFactory.imageView()
        }()
        
        private lazy var imageDark: UIImageView = {
            UIFactory.imageView()
        }()
        
        //
        // MARK: - View Life Cicle : Mandatory
        //
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        public override func prepareLayoutCreateHierarchy() {
            //addSubview(nevesView.container)
            addSubview(btnDismiss)
            addSubview(lblInfo)
            addSubview(image)
            addSubview(txtField)
            addSubview(btnOK)
            addSubview(lblTitle)
            addSubview(lblPostalCode)
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
//            nevesView.container.layouts.topToSuperview(offset: SizeNames.defaultMargin * 3)
//            nevesView.container.layouts.leadingToSuperview(offset: VM.Title.Constants.screenHorizontalMargin)
//            nevesView.container.layouts.trailingToSuperview(offset: VM.Title.Constants.screenHorizontalMargin)
//

            lblInfo.layouts.topToSuperview(offset: SizeNames.defaultMargin * 3)
            lblInfo.layouts.centerXToSuperview()
            lblInfo.layouts.leadingToSuperview(offset: VM.Title.Constants.screenHorizontalMargin)
            lblInfo.layouts.trailingToSuperview(offset: VM.Title.Constants.screenHorizontalMargin)
            
            image.layouts.topToSuperview(offset: SizeNames.defaultMargin * 3)
            image.layouts.trailing(to: lblInfo)
            image.heightAnchor.constraint(equalToConstant: VM.Title.Sizes.imageModeHeight).isActive = true
            image.widthAnchor.constraint(equalToConstant: VM.Title.Sizes.imageModeWidth).isActive = true
            
            lblTitle.layouts.topToBottom(of: image, offset: SizeNames.defaultMargin)
            lblTitle.layouts.centerXToSuperview()
            lblTitle.layouts.leadingToSuperview(offset: VM.Title.Constants.screenHorizontalMargin)
            lblTitle.layouts.trailingToSuperview(offset: VM.Title.Constants.screenHorizontalMargin)
            
//            btnOK.layouts.topToBottom(of: image, offset: SizeNames.defaultMargin)
//            btnOK.layouts.trailing(to: txtField, offset: SizeNames.defaultMargin)
//            btnOK.layouts.size(VM.Title.Sizes.btnOkSize)
            
            txtField.layouts.topToBottom(of: lblTitle, offset: SizeNames.defaultMargin)
            txtField.layouts.width(VM.Title.Sizes.txtFieldWidth)
            txtField.layouts.centerXToSuperview()
            
            btnOK.layouts.topToBottom(of: lblTitle, offset: SizeNames.defaultMargin)
            btnOK.layouts.trailing(to: txtField, offset: SizeNames.defaultMargin * 5)
            btnOK.layouts.size(VM.Title.Sizes.btnOkSize)
            btnOK.layouts.centerY(to: txtField)
            
            lblPostalCode.layouts.topToBottom(of: lblTitle, offset: SizeNames.defaultMargin)
            lblPostalCode.layouts.leadingToSuperview(offset: VM.Title.Constants.screenHorizontalMargin)
            lblPostalCode.layouts.centerY(to: txtField)
                      
            btnDismiss.layouts.topToBottom(of: txtField, offset: SizeNames.defaultMargin)
            btnDismiss.layouts.size(VM.Title.Sizes.btnDismissSize)
            btnDismiss.layouts.centerXToSuperview()
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        public override func prepareLayoutByFinishingPrepareLayout() {
            btnDismiss.setTitleForAllStates("Dismiss")
            btnOK.setTitleForAllStates("OK")
            image.image = ImageName.new.uiImage
            lblTitle.numberOfLines = 0
            lblTitle.text = ""
            lblPostalCode.text = ""
            lblInfo.numberOfLines = 0
            lblInfo.text = """
                * Use Case : A double tap on screen background will open Developer screen
                
                * Use Case : If there user and password are empty, the will display a blocking message
                
                * Use Case : If the user = '123' and password = '123' the user will login and information will be passed to next view controler
                
                * Use Case : If the user enters wrong password, the designabled will show a message
                
                * Use Case : The screen have "weird" colours and borders because UI Debug mode is enabled. Disable it on Feature Flags (inside Developer screen)
                
                * Use Case : The dismiss button will only work if a screen is presented (after user log in)

                """
            installDevViewOn(view: asView)
        }
        
        public override func setupColorsAndStyles() {
            backgroundGradient = installGradientBackground(backgroundGradient: backgroundGradient)
            backgroundColor = ColorSemantic.backgroundPrimary.uiColor
            lblInfo.applyStyle(.footnote, .labelSecondary)
            lblTitle.applyStyle(.title1, .labelPrimary)
            if traitCollection.userInterfaceStyle == .light {
                image.image = imageLight.image
            } else {
                image.image = imageDark.image
            }
            txtField.addBorder(width: 2, color: UIColor.black, animated: true)
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
//            nevesView.compoment.output.value.sink { [weak self] (result) in
//                guard let self = self else { return }
//                DevTools.Log.trace(result, .view)
//                switch result {
//                case .btnPressed(date: _, userName: let userName, password: let password):
//                    self.fwdStateToViewController(.userTyped(user: userName, password: password))
//                }
//            }.store(in: cancelBag)
//
//            // Fwd to ViewController
            btnOK.combine.touchUpInsidePublisher.sink { [weak self] (_) in
                guard let self = self else { return }
                if let txtFieldText = self.txtField.text {
                    self.fwdStateToViewController(.btnOKTapped(postalcode: txtFieldText))
                }
            }.store(in: cancelBag)
            
            btnDismiss.combine.touchUpInsidePublisher.sink { [weak self] (_) in
                guard let self = self else { return }
                self.fwdStateToViewController(.btnDismissTapped)
            }.store(in: cancelBag)
            
        }
    }
}

//
// MARK: - TitleViewProtocol
//

extension V.TitleView: TitleViewProtocol {
    
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

extension V.TitleView {

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
        case .displayData(city: let city, imageLight: let imageL, imageDark: let imageD):
            lblInfo.text = city
            lblTitle.text = "Check if you can discover the correct postal code for \(city)"
            imageLight.image = imageL
            imageDark.image = imageD
            if traitCollection.userInterfaceStyle == .light {
                image.image = imageL
            } else {
                image.image = imageD
            }
        
        case .displayMessage(message: let message):
            lblPostalCode.text = message
        }
    }
}

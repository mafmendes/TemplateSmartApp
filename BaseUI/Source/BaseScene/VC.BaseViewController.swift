//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
//
//import Toast
//
import Common
import BaseDomain
import DevTools
import AppConstants

// MARK: - ViewController - DisplayLogic

public protocol BaseViewControllerProtocol: AnyObject {
    func displayLoading(viewModel: BaseDisplayLogicModels.Loading)
    func displayError(viewModel: BaseDisplayLogicModels.Error)
    func displayWarning(viewModel: BaseDisplayLogicModels.Warning)
    func displayStatus(viewModel: BaseDisplayLogicModels.Status)
}

open class BaseViewController: UIViewController, BaseViewControllerProtocol {

    public private (set) var isFirstAppearance = true

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    open override func loadView() {
        super.loadView()
        doViewLifeCycle()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstAppearance {
            viewWillFirstAppear()
        }
    }

    open func viewWillFirstAppear() {
        guard isFirstAppearance else { return }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Common_Utils.delay { [weak self] in
            self?.isFirstAppearance = false
        }
    }
    
    open func displayStatus(viewModel: BaseDisplayLogicModels.Status) {
        var message = "\(viewModel.message)"
        if !viewModel.devMessage.isEmpty {
            message = "\(message)\n\nDEBUG MSG: \(viewModel.devMessage)"
        }
        displayMessage(title: viewModel.title, message, type: .success, actions: [])
    }

    open func displayWarning(viewModel: BaseDisplayLogicModels.Warning) {
        var message = "\(viewModel.message)"
        if !viewModel.devMessage.isEmpty {
            message = "\(message)\n\nDEBUG MSG: \(viewModel.devMessage)"
        }
        displayMessage(title: viewModel.title, message, type: .warning, actions: [])
    }
    
    open func displayError(viewModel: BaseDisplayLogicModels.Error) {
        var message = "\(viewModel.message)"
        if !viewModel.devMessage.isEmpty {
            message = "\(message)\n\nDEBUG MSG: \(viewModel.devMessage)"
        }
        displayMessage(title: viewModel.title, message, type: .error, actions: [])
    }
    
    open func displayLoading(viewModel: BaseDisplayLogicModels.Loading) {
        if viewModel.isLoading {
            
        } else {
            
        }
    }

    open func setupColorsAndStyles() {
        fatalError("Override me")
    }

    open func prepareLayoutCreateHierarchy() {
        fatalError("Override me")
    }

    open func prepareLayoutBySettingAutoLayoutsRules() {
        fatalError("Override me")
    }

    open func prepareLayoutByFinishingPrepareLayout() {
        fatalError("Override me")
    }
}

//
// MARK: - BaseViewProtocol
//

extension BaseViewController: BaseViewProtocol {
    public func displayMessage(title: String, _ message: String, type: AlertType, actions: [CommonNameSpace.AlertAction]) {
        // Should be overriden for a better user experience
        switch type {
        case .success: alert(title: "Sucess\n\(title)", message: message, actions: [])
        case .warning: alert(title: "Warning\n\(title)", message: message, actions: [])
        case .error: alert(title: "Error\n\(title)", message: message, actions: [])
        case .information: alert(title: "Information\n\(title)", message: message, actions: [])
        case .noTitle: alert(title: message, message: "", actions: actions)
        }
    }
}

//
// MARK: - Private
//

private extension BaseViewController {

    func doViewLifeCycle() {
        prepareLayoutCreateHierarchy()           // DONT CHANGE ORDER
        prepareLayoutBySettingAutoLayoutsRules() // DONT CHANGE ORDER
        prepareLayoutByFinishingPrepareLayout()  // DONT CHANGE ORDER
        setupColorsAndStyles()                   // DONT CHANGE ORDER
    }
}

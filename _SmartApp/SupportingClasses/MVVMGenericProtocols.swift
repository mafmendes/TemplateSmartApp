//
//  Created by Ricardo Santos on 20/03/2021.
//

import Foundation
import Combine
import UIKit
//
import Resources
import Common
import BaseDomain
import BaseUI
import AppDomain
import DevTools
import Designables
import AppConstants

//
// The reason that this file is here and not on BaseUI is that if we change it (to BaseUI), we wound need to turn
// all the associated types (view models) to public (and thats worst than having this file here)
//

//
// MARK: - View Protocol
//

protocol MVVMGenericViewProtocol {
    associatedtype ViewData: Hashable
    associatedtype ViewOutput: Hashable

    /// Used by external entities to update the view UI (internal state)
    var output: GenericObservableObjectForHashable<ViewOutput> { get set }
    
    /// Used by external the view to comunicate events to external entities
    var input: MVVMViewInputObservable<ViewData> { get set }
    
    func setupWith(viewModel: ViewData)
    func softReLoad()
    func handle(stateInput: MVVMViewInput<ViewData>)
    
    /// Sugar for View to send events to ViewController
    func fwdStateToViewController(_ state: ViewOutput) // Implemented on extension

}

extension MVVMGenericViewProtocol {

    /// Sugar for View to send events to ViewController
    func fwdStateToViewController(_ state: ViewOutput) {
        DevTools.Log.trace("\(state)", .view)
        output.value.send(state)
    }

}

protocol GenericViewProtocol {
    var cancelBag: CancelBag { get set }
    
    /// Show loading on element
    //func startLoading(at: UIView)
    
    /// Stop loading on element
    //func stopLoadingView(at: UIView)
    
}

//
// MARK: - ViewController Protocol
//

protocol GenericViewControllerProtocol {
    var cancelBag: CancelBag { get set }
}

extension GenericViewControllerProtocol {

}

protocol MVVMGenericViewControllerProtocol {
    associatedtype ViewModelSetup: Hashable // Data we migth want to pass to the VM
    associatedtype ViewModelProtocol: MVVMGenericViewModelProtocol
    associatedtype CoordinatorActions: Hashable

    var viewModel: ViewModelProtocol? { get set }
    var viewModelSetup: ViewModelSetup? { get set }
    var coordinatorActions: GenericObservableObjectForHashable<CoordinatorActions> { get set }
}

//
// MARK: - ViewModel Protocol
//

protocol MVVMGenericViewModelProtocol {
    
    /// View State (view binding model)
    associatedtype ViewData: Hashable

    /// Action Type
    associatedtype Action: Equatable
    
    /// Data we migth want to pass to the VM
    associatedtype ViewModelSetup: Hashable

    associatedtype CoordinatorActions: Hashable

    init(_ viewState: MVVMViewInputObservable<ViewData>,
         _ coordinatorActions: GenericObservableObjectForHashable<CoordinatorActions>,
         _ viewModelSetup: ViewModelSetup?)

    var viewState: MVVMViewInputObservable<ViewData> { get set }
    var coordinatorActions: GenericObservableObjectForHashable<CoordinatorActions> { get set }
    var viewModelSetup: ViewModelSetup? { get set }

    /// Actions sent from ViewController to ViewModel
    func send(_ action: Action)

    /// Sugar for ViewModel update (fwd state) ViewData on Coordinator
    func fwdStateToView(_ data: MVVMViewInput<ViewData>)
    
    /// Sugar for ViewModel update (fwd state) ViewData on View
    func fwdStateToCoordinator(_ data: CoordinatorActions)
    
    //
    // Presentation logic (ViewModel parses data before sends it to the view)
    //
    
    /// Default implementation to present errors
    func present(error: AppErrors, devMessage: String)
    func present(action: Action, some: Any?)
}

extension MVVMGenericViewModelProtocol {
    
    /// Default implementation to present errors
    func present(error: AppErrors, devMessage: String) {
        DevTools.Log.error(error, .viewModel)
        fwdStateToView(.loading(.init(isLoading: false, devMessage: devMessage)))
        fwdStateToView(.error(error, devMessage: "[\(devMessage)] [\(error.localisedForDevTeam!)]\n\nLocation: [\(Self.self)]"))
    }
    
    /// Sugar for ViewModel update (fwd state) ViewData on View
    func fwdStateToView(_ data: MVVMViewInput<ViewData>) {
        DevTools.Log.trace("\(data)", .viewModel)
        // swiftlint:disable mvvmRule_2
        viewState.value.send(data)
        // swiftlint:enable mvvmRule_2
    }
    
    func fwdStateToCoordinator(_ data: CoordinatorActions) {
        DevTools.Log.trace("\(data)", .viewModel)
        // swiftlint:disable mvvmRule_3
        coordinatorActions.value.send(data)
        // swiftlint:enable mvvmRule_3
    }
}

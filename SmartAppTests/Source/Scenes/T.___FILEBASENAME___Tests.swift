//
//  Created by Ricardo Santos on 01/03/2021.
//

/// @testable import cames from the ´PRODUCT_NAME´ on __.xcconfig__ file

@testable import Smart_Dev   // Testing on target "SmartApp Dev" :
//@testable import Smart_App // Testing on target "SmartApp Production"

//
import XCTest
import Combine
import Nimble
//
import Common
import BaseUI
import AppCore
import AppDomain
import DevTools

private extension ___VARIABLE_sceneName___Tests {
    
    func auxiliarStartDefaultObservers(vc: VC.___VARIABLE_sceneName___ViewController?) {
        ///
        /// Observing ViewModel from ViewController to make sure ViewModel is sending events
        ///
        vc?.viewModel?.viewState.value.sink { (state) in
            receivedBy_vc_viewModel_viewState.append(state.selfValue)
            if let value = state.value { loadedDataSentBy_ViewModel = value }
        }.store(in: cancelBag)

        ///
        /// Observing View from ViewController to make sure View receivs events
        ///
        vc?.genericView.input.value.sink { (state) in
            receivedBy_genericView_viewInput.append(state.selfValue)
            if let value = state.value { loadedDataReceivedBy_View = value }
        }.store(in: cancelBag)
        
        ///
        /// Observing ViewModel from ViewController to make sure ViewModel is sending events
        ///
        vc?.coordinatorActions.value.sink { (state) in
            receivedBy_ViewControllerCoordinator = state.self
        }.store(in: cancelBag)
    }
}

class ___VARIABLE_sceneName___Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        receivedBy_vc_viewModel_viewState = []
        loadedDataSentBy_ViewModel = nil
        receivedBy_genericView_viewInput = []
        loadedDataReceivedBy_View = nil
        receivedBy_ViewControllerCoordinator = nil
        loadedAny = nil
    }
    
    ///
    /// Testing View and ViewModel for screen initial state
    ///
    func test___VARIABLE_sceneName___ScreenFirstLoad() throws {
        let vc = VC.___VARIABLE_sceneName___ViewController.instance(with: .init(name: ""))
        expect(vc != nil).to(beTrue())

        auxiliarStartDefaultObservers(vc: vc)

        ///
        /// __TEST TRIGGER__
        /// 
        /// Simulate first appear (when ViewController send [load] event to ViewModel
        ///
        vc?.viewWillFirstAppear()

        ///
        /// View assert:
        /// 1 - Received events != nil
        /// 2 - The order of the events was [loading] and then [loaded]
        ///
        expect(loadedDataReceivedBy_View != nil).toEventually(beTrue(), timeout: .seconds(timeout))
        expect(receivedBy_genericView_viewInput)
            .toEventually(contain(RawValues.loading, RawValues.loaded), timeout: .seconds(timeout))
        
        ///
        /// ViewModel assert:
        /// 1 - Sent events != nil
        /// 2 - The order of the events was [loading] and then [loaded]
        ///
        expect(loadedDataSentBy_ViewModel != nil).toEventually(beTrue(), timeout: .seconds(timeout))
        expect(receivedBy_vc_viewModel_viewState)
            .toEventually(contain(RawValues.loading, RawValues.loaded), timeout: .seconds(timeout))

    }
    
    ///
    /// Testing View and ViewModel for screen action send by View
    ///
    func test___VARIABLE_sceneName___ViewActionTapDismiss() throws {
        let vc = VC.___VARIABLE_sceneName___ViewController.instance(with: .init(name: ""))
        expect(vc != nil).to(beTrue())

        auxiliarStartDefaultObservers(vc: vc)
        
        ///
        /// __TEST TRIGGER__
        /// 
        //vc?.genericView.simulateBtnDismissTap()

        ///
        /// ViewController coordinator assert:
        /// 1 - Received events != nil
        ///
        expect(receivedBy_ViewControllerCoordinator != nil).toEventually(beTrue(), timeout: .seconds(timeout))
    
    }
    
    ///
    /// Testing View and ViewModel for screen action send by View
    ///
    func test___VARIABLE_sceneName___ViewActionTap() throws {
        let vc = VC.___VARIABLE_sceneName___ViewController.instance(with: .init(name: ""))
        expect(vc != nil).to(beTrue())

        auxiliarStartDefaultObservers(vc: vc)
        
        ///
        /// __TEST TRIGGER__
        /// 
        //vc?.genericView.simulateBtnDismissTap()

        ///
        /// ViewController coordinator assert:
        /// 1 - Received events != nil
        ///
        expect(receivedBy_ViewControllerCoordinator != nil).toEventually(beTrue(), timeout: .seconds(timeout))
        
        ///
        /// View assert:
        /// 1 - Received events != nil
        /// 2 - Receive [loaded]
        ///
        expect(loadedDataReceivedBy_View != nil).toEventually(beTrue(), timeout: .seconds(timeout))
        expect(receivedBy_genericView_viewInput)
            .toEventually(contain(RawValues.loaded), timeout: .seconds(timeout))
        
        ///
        /// ViewModel assert:
        /// 1 - Sent events != nil
        /// 2 - Receive [loaded]
        ///
        expect(loadedDataSentBy_ViewModel != nil).toEventually(beTrue(), timeout: .seconds(timeout))
        expect(receivedBy_vc_viewModel_viewState)
            .toEventually(contain(RawValues.loaded), timeout: .seconds(timeout))

    }

}

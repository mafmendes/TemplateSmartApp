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

let cancelBag = CancelBag()
let timeout: Int = 5

struct RawValues {
    static let loading = MVVMViewInput<String>.loading(.init(isLoading: false, devMessage: "")).selfValue
    static let loaded  = MVVMViewInput<String>.loaded("").selfValue
}

var receivedBy_vc_viewModel_viewState: [Int] = [] // List of events (loading, loaded, etc)
var loadedDataSentBy_ViewModel: Any?              // Content of the .loaded(some) event

var receivedBy_genericView_viewInput: [Int] = []  // List of events/actions (loading, loaded, etc) that the view received
var loadedDataReceivedBy_View: Any?               // Content of the .loaded(some) event

var receivedBy_ViewControllerCoordinator: Any?    // Event received on coordinator

var loadedAny: Any?

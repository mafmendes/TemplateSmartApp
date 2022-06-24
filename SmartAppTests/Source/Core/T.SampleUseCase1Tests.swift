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
import WebAPIDomain
import WebAPICore

class SampleUseCase1Tests: XCTestCase {
    private let cancelBag = CancelBag()
    private let timeout: Int = 5

    private var sampleUseCase1: SampleUseCase1Protocol = CoreProtocolsResolved.sampleUseCase1Protocol
    
    private var loadedAnyList: [Any] {
        return loadedAny as? [Any] ?? []
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        receivedBy_vc_viewModel_viewState = []
        loadedDataSentBy_ViewModel = nil
        receivedBy_genericView_viewInput = []
        loadedDataReceivedBy_View = nil
        receivedBy_ViewControllerCoordinator = nil
        loadedAny = nil
    }

    func testLoginSucess() throws {
        sampleUseCase1.requestLoginWith(user: "123", password: "123")
            .sinkToReceiveValue({ (some) in
                loadedAny = some.sucessUnWrappedValue
        }).store(in: cancelBag)
        expect(loadedAny != nil).toEventually(beTrue(), timeout: .seconds(timeout))
    }
    
    func testLoginFail() throws {
        sampleUseCase1.requestLoginWith(user: String.random(5), password: String.random(5))
            .sinkToReceiveValue({ (some) in
                loadedAny = some.sucessUnWrappedValue
        }).store(in: cancelBag)
        expect(loadedAny != nil).toEventually(beTrue(), timeout: .seconds(timeout))
    }
    
}

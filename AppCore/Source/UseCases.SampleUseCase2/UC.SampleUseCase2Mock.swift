//
//  Created by Ricardo Santos on 28/02/2021.
//

import Foundation
import Combine
import UIKit
//
import Common
import WebAPIDomain
import BaseDomain
import AppDomain
import DevTools
import AppConstants

public class SampleUseCase2Mock: GenericMockProtocol {
    
    public var sampleRepository1: SampleRepository1Protocol! // Repository
    
    private var acessToken: String = ""

    required public init(initialState: [String]) {
        self.initialState = initialState
    }
    private var cancelBag: CancelBag = CancelBag()

    public var initialState: [String] //[Model.AccountNavigationBar]
    public init() {
        self.initialState = []
    }
}

extension SampleUseCase2Mock: SampleUseCase2Protocol {
    
    //
    // MARK: - Dummy
    //
    
    public func requestDummy() -> ResponseDummy {
        fatalError("not implemented")
    }
    
}

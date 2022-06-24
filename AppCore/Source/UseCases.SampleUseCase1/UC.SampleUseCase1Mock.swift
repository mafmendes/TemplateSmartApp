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
import Resources

#warning("Tutorial: UC.xxxxxUseCaseProtocol - Use Case(s) MOCK Protocol implementation")

public class SampleUseCase1Mock: GenericMockProtocol {
    
    public var sampleRepository1: SampleRepository1Protocol! // Repository
    
    public var loginAndSessionUseCase: SampleUseCase2Protocol!
    
    required public init(initialState: [Model.Login]) {
        self.initialState = initialState
    }
    
    public var initialState: [Model.Login]
    public init() {
        self.initialState = [
            Model.Login()
        ]
    }
}

extension SampleUseCase1Mock: SampleUseCase1Protocol {

    public func requestLoginWith(user: String, password: String) -> ResponseLoginWith {
        
        var model = Model.Login()
        model.sucess = user == "123" && password == "123"
        
        // Both options work
        if Bool.random() {
            return Future { promise in
                Common_Utils.delay(AppConstantsNameSpace.TimeIntervals.defaultDelayMocks) {
                    promise(.success(model))
                }
            }.eraseToAnyPublisher()
        } else {
            return Just(model)
                .setFailureType(to: AppErrors.self)
                .eraseToAnyPublisher()
                .delay(seconds: AppConstantsNameSpace.TimeIntervals.defaultDelayMocks)
        }
    }
    
    public func requestZipCodesWhereStored() -> ResponseZipCodesWhereStored {
        return Just(true)
            .setFailureType(to: AppErrors.self)
            .eraseToAnyPublisher()
            .delay(seconds: AppConstantsNameSpace.TimeIntervals.defaultDelayMocks)
    }
    
    public func requestZipCodes(filter: String) -> ResponseZipCodes {
        fatalError("Not implemented")
    }

}

//
//  Created by Ricardo Santos on 28/02/2021.
//

import Foundation
import Combine
import CoreData
//
import Common
import WebAPIDomain
import BaseDomain
import AppDomain
import DevTools
import AppConstants

public class SampleUseCase2: SampleUseCase2Protocol {

    public init() { }
    private let cancelBag = CancelBag()
    
    public var sampleRepository1: SampleRepository1Protocol! // Repository
        
    //
    // MARK: - Dummy
    //
    
    public func requestDummy() -> ResponseDummy {
        fatalError("not implemented")
    }
    
}

//
// MARK: - Private
//

fileprivate extension SampleUseCase2 {
    
}

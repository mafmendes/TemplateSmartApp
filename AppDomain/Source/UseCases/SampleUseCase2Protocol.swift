//
//  Created by Ricardo Santos on 17/03/2021.
//

import Foundation
import Combine
import UIKit
//
import BaseDomain
import Common

public protocol SampleUseCase2Protocol {
    
    var sampleRepository1: SampleRepository1Protocol! { get set } // Repository
    
    //
    // MARK: - Dummy
    // Methods naming convention : If whe something something called `Dummy`, then ->
    //
    func requestDummy() -> ResponseDummy
    typealias ResponseDummy = AnyPublisher<[Model.Login], AppErrors>
    
}

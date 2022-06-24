//
//  Created by Ricardo Santos on 17/03/2021.
//

import Foundation
import Combine
import UIKit
//
import BaseDomain
import Common

#warning("Tutorial: UC.xxxxxUseCaseProtocol - Use Case(s) Protocol declaraction")

public enum SampleUseCase1ProtocolOutput: Hashable {
    case userDidLogin(user: String?)
}

public protocol SampleUseCase1Protocol {
    
    var sampleRepository1: SampleRepository1Protocol! { get set } // Repository
        
    //
    // Methods naming convention :
    // If we are requesting something called [LoginWith], then ->
    // 1 : method name is [reques][LoginWith] and
    // 2 : Response is [Response][LoginWith]
    //
    
    /// If the user is valid, returns the user model
    func requestLoginWith(user: String, password: String) -> ResponseLoginWith
    typealias ResponseLoginWith = AnyPublisher<Model.Login, AppErrors>
    
    /// Request the zip codes filtering by the _param_
    func requestZipCodes(filter: String) -> ResponseZipCodes
    typealias ResponseZipCodes = AnyPublisher<[Model.PortugueseZipCode], AppErrors>
    
    /// Returns _true_ if the records where download and stored (ready to use)
    func requestZipCodesWhereStored() -> ResponseZipCodesWhereStored
    typealias ResponseZipCodesWhereStored = AnyPublisher<Bool, AppErrors>
}

//
//  Created by Santos, Ricardo Patricio dos  on 05/12/2021.
//

import Foundation
import Combine
//
import BaseDomain
import Common

public protocol WebAPIZipCodesProtocol {
    
    func requestZipCodes(_ resquestDto: ModelDto.PortugueseZipCodeRequest) -> ZipCodesResponse
    typealias ZipCodesResponse = AnyPublisher<[ModelDto.PortugueseZipCodeResponse], Common_FRPNetworkAgentAPIError>
        
}

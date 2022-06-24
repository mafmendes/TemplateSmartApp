//
//  Created by Ricardo P Santos on 2020.
//  2020 © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
//
import Combine

protocol FRPSampleAPIRequestProtocol {
    func sampleRequestJSON(_ resquestDto: FRPSampleAPI.RequestDto.Employee) ->
        AnyPublisher<FRPSampleAPI.ResponseDto.EmployeeServiceAvailability, Common_FRPNetworkAgentAPIError>
    
    func sampleRequestCVS(_ resquestDto: FRPSampleAPI.RequestDto.PortugueseZipCode) ->
        AnyPublisher<[FRPSampleAPI.ResponseDto.PortugueseZipCode], Common_FRPNetworkAgentAPIError>
    
    @available(iOS 15.0.0, *)
    func sampleRequestCVSAssync(_ resquestDto: FRPSampleAPI.RequestDto.Employee) async throws -> FRPSampleAPI.ResponseDto.EmployeeServiceAvailability
}

public class FRPSampleAPI: Common_FRPNetworkAgentProtocol, FRPSampleAPIRequestProtocol {
    public var client = Common_FRPSimpleNetworkAgent(session: URLSession.defaultForConnectivity)
     //private var agent1 = Common_FRPSimpleNetworkAgent()
     //private var agent2 = Common_FRPSimpleNetworkAgent(session: URLSession.defaultForConnectivity)
     //private var agent3 = Common_FRPSimpleNetworkAgent(session: URLSession.shared)
}

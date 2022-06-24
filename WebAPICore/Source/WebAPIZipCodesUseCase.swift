//
//  Created by Santos, Ricardo Patricio dos  on 05/12/2021.
//

import Foundation
//
import BaseDomain
import Common
import WebAPIDomain

public class WebAPIZipCodesUseCase: Common_FRPNetworkAgentProtocol {
    public var client = Common_FRPSimpleNetworkAgent(session: URLSession.defaultForConnectivity)
     //private var agent1 = Common_FRPSimpleNetworkAgent()
     //private var agent2 = Common_FRPSimpleNetworkAgent(session: URLSession.defaultForConnectivity)
     //private var agent3 = Common_FRPSimpleNetworkAgent(session: URLSession.shared)
    
    public init() {
        
    }
}

//
// MARK: - Requests
//

extension WebAPIZipCodesUseCase: WebAPIZipCodesProtocol {
    
    /// Takes about 15s
    public func requestZipCodes(_ resquestDto: ModelDto.PortugueseZipCodeRequest) -> ZipCodesResponse {
        let request = RequestsBuilder.requestZipCodes(resquestDto)
        return client.runV1(request.urlRequest!, JSONDecoder(), false, request.responseFormat).map(\.value).eraseToAnyPublisher() 
    }
}

//
// MARK: - Requests Builders
//

private struct RequestsBuilder {
    static func requestZipCodes(_ resquestDto: ModelDto.PortugueseZipCodeRequest) -> Common_FRPNetworkAgentRequestModel {
        return Common_FRPNetworkAgentRequestModel(path: resquestDto.path, //"codigos_postais.csv",
                            httpMethod: .get,
                            httpBody: nil,
                            headerValues: nil,
                            serverURL: "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data",
                            responseType: .csv)
    }
}

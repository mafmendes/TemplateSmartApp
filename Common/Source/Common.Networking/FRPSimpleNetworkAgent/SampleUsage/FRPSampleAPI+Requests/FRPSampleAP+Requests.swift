//
//  Created by Ricardo P Santos on 2020.
//  2020 © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import Combine
import CryptoKit

//
// MARK: - FRPSampleAPI
//

extension FRPSampleAPI {
    func sampleRequestJSON(_ resquestDto: FRPSampleAPI.RequestDto.Employee) -> AnyPublisher<FRPSampleAPI.ResponseDto.EmployeeServiceAvailability, Common_FRPNetworkAgentAPIError> {
        let request = Self.sampleRequestJSON(resquestDto)
        return client.runV1(request.urlRequest!, JSONDecoder(), false, request.responseFormat).map(\.value).eraseToAnyPublisher() // Not using extension
    }

    func sampleRequestCVS(_ resquestDto: FRPSampleAPI.RequestDto.PortugueseZipCode)
    -> AnyPublisher<[FRPSampleAPI.ResponseDto.PortugueseZipCode], Common_FRPNetworkAgentAPIError> {
        let request = Self.sampleRequestCSV(resquestDto)
        return runV1(request: request.urlRequest!, dumpResponse: false, responseType: request.responseFormat) // Using extension
    }
    
    @available(iOS 15.0.0, *)
    func sampleRequestCVSAssync(_ resquestDto: FRPSampleAPI.RequestDto.Employee) async throws -> FRPSampleAPI.ResponseDto.EmployeeServiceAvailability {
        let request = Self.sampleRequestJSON(resquestDto)
        return try await runV2(request: request.urlRequest!, decoder: JSONDecoder(), dumpResponse: false, responseType: request.responseFormat) // Using extension
    }
}

//
// MARK: - RequestsBuilder
//

fileprivate extension FRPSampleAPI {
    static func sampleRequestJSON(_ resquestDto: FRPSampleAPI.RequestDto.Employee) -> Common_FRPNetworkAgentRequestModel {
        let /*httpBody*/ _ = [
            "publicKey": resquestDto.someParam
        ]
        let /*headerValues*/ _ = [
            "userId": resquestDto.someParam
        ]
        return Common_FRPNetworkAgentRequestModel(path: "v1/employees",
                            httpMethod: .get,
                            httpBody: nil,
                            headerValues: nil,
                            serverURL: "http://dummy.restapiexample.com/api",
                            responseType: .json)
    }

    static func sampleRequestCSV(_ resquestDto: FRPSampleAPI.RequestDto.PortugueseZipCode) -> Common_FRPNetworkAgentRequestModel {
        return Common_FRPNetworkAgentRequestModel(path: "codigos_postais.csv",
                            httpMethod: .get,
                            httpBody: nil,
                            headerValues: nil,
                            serverURL: "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data",
                            responseType: .csv)
    }
}

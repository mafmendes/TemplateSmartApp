import Foundation
import Combine

// swiftlint:disable logs_rule_1

//
// FRPSimpleNetworkAgent (Combine version) was inspired on
// https://www.vadimbulavin.com/modern-networking-in-swift-5-with-urlsession-combine-framework-and-codable/ and
// https://medium.com/swlh/better-api-management-in-swift-c2c1ad6354be
// and assync version on
// https://medium.com/geekculture/create-a-generic-networking-layer-using-async-await-9168b6281721 and
// https://www.avanderlee.com/swift/async-await/
//

/**
 Agent is a promise-based HTTP client. It fulfils and configures requests by passing a single URLRequest object to it.
 The agent automatically transforms JSON data into a Codable value and returns an AnyPublisher instance:
 
 1 - Response<T> carries both parsed value and a URLResponse instance. The latter can be used for status code validation and logging.
 2 - The run<T>() method is the single entry point for requests execution. It accepts a URLRequest instance that fully
 describes the request configuration. The decoder is optional in case custom JSON parsing is needed.
 3 - Create data task as a Combine publisher.
 4 - Parse JSON data. We have constrained T to be Decodable in the run<T>() method declaration.
 5 - Create the Response<T> object and pass it downstream. It contains the parsed value and the URL response.
 6 - Deliver values on the main thread.
 7 - Erase publisher’s type and return an instance of AnyPublisher.
 */

extension NetworkinNameSpace {
    public class FRPSimpleNetworkAgent {
        private (set) var session: URLSession
        public init() {
            // self.session = .shared
            self.session = URLSession.defaultForConnectivity
        }
        public init(session: URLSession) {
            self.session = session
        }
    }
}

public extension Common_FRPSimpleNetworkAgent {
        
    // 2
    func runV1<T>(_ request: URLRequest,
                  _ decoder: JSONDecoder,
                  _ dumpResponse: Bool,
                  _ responseFormat: Common_NetworkClientResponseFormat) -> AnyPublisher<Common_Response<T>, Common_FRPNetworkAgentAPIError> where T: Decodable {
        
        let requestDebugDump = "\(request) : \(T.self))"
        return session
            .dataTaskPublisher(for: request) // 3
            .tryMap { [weak self] result -> Common_Response<T> in
                guard let self = self else { throw Common_FRPNetworkAgentAPIError.ok }
                if dumpResponse {
                    let response = String(decoding: result.data, as: UTF8.self).prefix(500)
                    Common_Logs.debug("# Request: [\(requestDebugDump)]\n# \(response)")
                }
                
                let responseEval = self.responseIsValid(result.response)
                guard responseEval.isValid else {
                    throw responseEval.error
                }

                let value: T = try self.decode(result.data, decoder, responseFormat)
                return Common_Response(value: value, response: result.response)  // 5

            }
            .mapError { error in
                Common_Logs.error(self.debugStringWith(requestDebugDump, error))
                return Common_FRPNetworkAgentAPIError.network(description: error.localizedDescription)
            }
            .receive(on: DispatchQueue.main) // 6
            .eraseToAnyPublisher()           // 7
        
    }
    
    @available(iOS 15.0.0, *)
    func runV2<T: Decodable>(
        _ request: URLRequest,
        _ decoder: JSONDecoder,
        _ dumpResponse: Bool,
        _ responseFormat: Common_NetworkClientResponseFormat) async throws -> T {
            
            let requestDebugDump = "\(request) : \(T.self))"
            
            let (data, urlResponse) = try await session.data(for: request)

            if dumpResponse {
                let response = String(decoding: data, as: UTF8.self).prefix(500)
                Common_Logs.debug("# Request: [\(requestDebugDump)]\n# \(response)")
            }
            
            let responseEval = self.responseIsValid(urlResponse)
            guard responseEval.isValid else {
                throw responseEval.error
            }
            
            do {
                return try self.decode(data, decoder, responseFormat)
            } catch {
                Common_Logs.error(self.debugStringWith(requestDebugDump, error))
                throw Common_FRPNetworkAgentAPIError.network(description: error.localizedDescription)
            }

        }
}

//
// MARK : Private shared code
//

fileprivate extension Common_FRPSimpleNetworkAgent {
        
    func debugStringWith(_ acc: String, _ error: Error) -> String {
        let result = """
        # Request [\(acc)] failed
        # [\(error.localizedDescription)]
        # [\(error)]
        """
        return result
    }
    
    func responseIsValid(_ urlResponse: Any?) -> (isValid: Bool, error: Common_FRPNetworkAgentAPIError) {
        
        guard let httpResponse = urlResponse as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            if let code = (urlResponse as? HTTPURLResponse)?.statusCode {
                return (false, Common_FRPNetworkAgentAPIError.failedWithStatusCode(code: code))
            } else {
                return (false, Common_FRPNetworkAgentAPIError.genericError)
            }
        }
        return (true, .ok)
    }
    
    func decode<T: Decodable>(_ data: Data, _ decoder: JSONDecoder, _ responseFormat: Common_NetworkClientResponseFormat) throws -> T {
        switch responseFormat {
        case .json:
            return try decoder.decodeFriendly(T.self, from: data) // 4
        case .csv:
            let data = try NetworkinNameSpace.NetworkAgentUtils.parseCSV(data: data)
            return try decoder.decodeFriendly(T.self, from: data)
       
        }
    }
}

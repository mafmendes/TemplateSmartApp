//
//  Created by Ricardo Santos on 29/01/2021.
//

import Foundation
import Network
import Combine
#if !os(watchOS)
import SystemConfiguration
#endif

public extension CommonNameSpace {
    struct NetworkUtils {
        private init() { }
    }
}

// https://www.vadimbulavin.com/network-connectivity-on-ios-with-swift/

public extension CommonNameSpace.NetworkUtils {
    struct NetworMonitor {
        private init() {
            monitor = NWPathMonitor()
            if true {
                monitor.pathUpdateHandler = customPathUpdateHandler
                monitor.start(queue: queue)
            } else {
                monitor.start(queue: .global())
            }
        }
        public static var shared = Common_NetworMonitor()
        public var monitor: NWPathMonitor!

        private let queue = DispatchQueue.init(label: "monitor queue", qos: .userInitiated)
        public let customPathUpdateHandler = {(path: NWPath) in
            let availableInterfaces = path.availableInterfaces
            if !availableInterfaces.isEmpty {
                //e.g. [ipsec4, en0, pdp_ip0]
                let list = availableInterfaces.map { $0.debugDescription }.joined(separator: "\n")
            }
            var status = "undetermined"
            switch path.status {
            case .requiresConnection: status = "requires connection"
            case .satisfied: status = "satisfied"
            case .unsatisfied: status = "unsatisfied"
            @unknown default: status = "unsatisfied"
            }
        }
        
        public func pathUpdate1() -> Future<Bool, Never> {

            Future { promise in
                NetworMonitor.shared.monitor.pathUpdateHandler = { path in
                    if path.status == .satisfied {
                        promise(.success(true))
                    } else {
                        promise(.success(false))
                    }
                }
            }
        }
    }
}

extension Publishers {
    
    class DataSubscription<S: Subscriber>: Subscription where S.Input == Data, S.Failure == Error {
        private let session = URLSession.shared
        private let request: URLRequest
        private var subscriber: S?
        
        init(request: URLRequest, subscriber: S) {
            self.request = request
            self.subscriber = subscriber
            sendRequest()
        }
        
        func request(_ demand: Subscribers.Demand) {
            // Optionaly Adjust The Demand
        }
        
        func cancel() {
            subscriber = nil
        }
        
        private func sendRequest() {
            guard let subscriber = subscriber else { return }
            session.dataTask(with: request) { (data, _, error) in
                _ = data.map(subscriber.receive)
                _ = error.map { subscriber.receive(completion: Subscribers.Completion.failure($0)) }
            }.resume()
        }
    }
}

extension Publishers {
    
    struct DataPublisher: Publisher {
        typealias Output = Data
        typealias Failure = Error
        
        private let urlRequest: URLRequest
        
        init(urlRequest: URLRequest) {
            self.urlRequest = urlRequest
        }
        
        func receive<S: Subscriber>(subscriber: S) where
            DataPublisher.Failure == S.Failure, DataPublisher.Output == S.Input {
                let subscription = DataSubscription(request: urlRequest,
                                                    subscriber: subscriber)
                subscriber.receive(subscription: subscription)
        }
    }
}

extension URLSession {
    func dataResponse(for request: URLRequest) -> Publishers.DataPublisher {
        return Publishers.DataPublisher(urlRequest: request)
    }
}

public extension CommonNameSpace.NetworkUtils {
     struct Reachability {
        private init() { }
        public static var isConnectedToNetwork: Bool {
            var zeroAddress              = sockaddr_in()
            zeroAddress.sin_len          = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family       = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable     = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
    }
}

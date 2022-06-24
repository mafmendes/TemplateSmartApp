//
//  Created by Ricardo Santos on 21/03/2021.
//

import Foundation
//
import Common
import DevTools
import WebAPIDomain
import AppDomain
import WebAPICore

//
// Naming convention
// 1 : If the protocols is name [ImTheProtocolUseCaseProtocol], the var will be named [imTheProtocolUseCaseProtocol]
// 2 : The use case protocol name allways end with [UseCaseProtocol]
//

public extension AppCoreNameSpace {
    struct AppCoreProtocolsNamed {
        private init() { }
        static let webAPIZipCodesProtocol    = WebAPIZipCodesProtocol.self
        static let sampleUseCase1Protocol    = SampleUseCase1Protocol.self
        static let sampleUseCase2Protocol    = SampleUseCase2Protocol.self
        static let sampleRepository1Protocol = SampleRepository1Protocol.self
    }
}

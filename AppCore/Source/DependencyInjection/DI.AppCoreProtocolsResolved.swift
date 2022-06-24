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

    struct CoreProtocolsResolved {
        private init() { }
               
        public static var sampleRepository1Protocol: SampleRepository1Protocol {
            /// Instead of writing `AppCoreAssembly.shared.container.resolve(AppCoreProtocols.sampleRepository1Protocol)!` to get a resolved
            /// protocol implementation, we can just writh `AppCoreNameSpace.CoreProtocolsResolved.sampleRepository1Protocol`
            AppCoreAssembly.shared.container.resolve(AppCoreProtocolsNamed.sampleRepository1Protocol)!
        }
        
        public static var networkManager: WebAPIZipCodesProtocol {
            /// Instead of writing `AppCoreAssembly.shared.container.resolve(AppCoreProtocols.webAPIZipCodesProtocol)!` to get a resolved
            /// protocol implementation, we can just writh `AppCoreNameSpace.CoreProtocolsResolved.webAPIZipCodesProtocol`
            AppCoreAssembly.shared.container.resolve(AppCoreProtocolsNamed.webAPIZipCodesProtocol)!
        }
        
        public static var sampleUseCase1Protocol: SampleUseCase1Protocol {
            /// Instead of writing `AppCoreAssembly.shared.container.resolve(AppCoreProtocols.sampleUseCase1Protocol)!` to get a resolved
            /// protocol implementation, we can just writh `AppCoreNameSpace.CoreProtocolsResolved.sampleUseCase1Protocol`
            AppCoreAssembly.shared.container.resolve(AppCoreProtocolsNamed.sampleUseCase1Protocol)!
        }
        
        public static var sampleUseCase2Protocol: SampleUseCase2Protocol {
            /// Instead of writing `AppCoreAssembly.shared.container.resolve(AppCoreProtocols.sampleUseCase2Protocol)!` to get a resolved
            /// protocol implementation, we can just writh `AppCoreNameSpace.CoreProtocolsResolved.sampleUseCase2Protocol`
            AppCoreAssembly.shared.container.resolve(AppCoreProtocolsNamed.sampleUseCase2Protocol)!
        }
        
    }
}

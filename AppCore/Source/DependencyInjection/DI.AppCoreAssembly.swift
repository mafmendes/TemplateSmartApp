//
//  Created by Ricardo Santos on 21/03/2021.
//

import Foundation
//
import Swinject
//
import Common
import DevTools
import WebAPIDomain
import AppDomain
import WebAPICore
import AppConstants

public extension AppCoreNameSpace {

    final class AppCoreAssembly {
        private init() { }
        public static var shared = AppCoreAssembly()

        public var container: Container = {
            // swiftlint:disable force_cast
            AppCoreAssembly.assembler.resolver as! Container
            // swiftlint:enable force_cast
        }()

        public class var assembler: Assembler {
            let assemblyList: [Assembly] = [RootAssemblyContainer()]
            return Assembler(assemblyList)
        }
    }
}

public extension AppCoreNameSpace {

    final class RootAssemblyContainer: Assembly {

        #warning("Tutorial : AppCore dependencies solving")
        public func assemble(container: Container) {

            //
            // ####################################
            // # Repositorys
            // ####################################
            //
            
            // Storage....
            container.register(AppCoreProtocols.sampleRepository1Protocol) { /* resolver */ _ in
                let resolving = SampleRepository()
                return resolving
            }
            
            // WebAPI....
            container.register(AppCoreProtocols.webAPIZipCodesProtocol) { /* resolver */ _ in
                let resolving = WebAPIZipCodesUseCase()
                return resolving
            }
            
            //
            // ####################################
            // # Use Cases
            // ####################################
            //
            
            container.register(AppCoreProtocolsNamed.sampleUseCase1Protocol) { resolver in
                var resolving: SampleUseCase1Protocol = !DevTools.onTargetMock ? SampleUseCase1() : SampleUseCase1Mock()
                resolving.sampleRepository1 = resolver.resolve(AppCoreProtocols.sampleRepository1Protocol)
                return resolving
            }
            
            container.register(AppCoreProtocolsNamed.sampleUseCase2Protocol) { resolver in
                var resolving: SampleUseCase2Protocol = !DevTools.onTargetMock ? SampleUseCase2() : SampleUseCase2Mock()
                resolving.sampleRepository1 = resolver.resolve(AppCoreProtocols.sampleRepository1Protocol)
                return resolving
            }
        }
    }
}

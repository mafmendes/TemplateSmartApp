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

public extension SmartAppNameSpace {

    final class SmartAppAssembly {
        private init() { }
        public static var shared = SmartAppAssembly()
        public var container: Container = {
            // swiftlint:disable force_cast
            SmartAppAssembly.assembler.resolver as! Container
            // swiftlint:enable force_cast
        }()

        #warning("Tutorial : App Screens dependencies solving. Eache Scene added to the app, must be registered here")

        public class var assembler: Assembler {
            let assemblyList: [Assembly] = [
                RootAssemblyContainer(),
                DI.___VARIABLE_sceneName___Assembly(),
                DI.ZipCodesListAssembly(),
                DI.TextFieldAssembly(),
                DI.ZipCodesListUIAssembly(),
                DI.TitleAssembly(),
                DI.MoviesAssembly(),
                DI.MovieScreenDetailAssembly()
            ]
            return Assembler(assemblyList)
        }
    }
}

public extension SmartAppNameSpace {
    final class RootAssemblyContainer: Assembly {
        public func assemble(container: Container) {
            // No need for now
        }
    }
}

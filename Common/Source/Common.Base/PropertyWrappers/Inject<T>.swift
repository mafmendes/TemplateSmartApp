//
//  Created by Ricardo P Santos on 2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
#if !os(watchOS)
import SystemConfiguration
#endif

// swiftlint:disable logs_rule_1

//
// https://avdyushin.ru/posts/swift-property-wrappers/
// https://medium.com/@anuragajwani/dependency-injection-in-ios-and-swift-using-property-wrappers-f411117cfdcf
//

public extension CommonNameSpace {

    /**
     __Usage__
     
     ```
     RJS_Resolver.shared.register(type: SomeProtocol.self, { SomeImplementation() })
     ```
     
     ```
     @RJS_Inject private var xxx: SomeProtocol
     ```
     */
    class Container {
        public static let shared = Container()
        public var factoryDict: [String: () -> Any] = [:]
        public func register<Service>(type: Service.Type, _ factory: @escaping () -> Service) {
            factoryDict[String(describing: type.self)] = factory
        }
        public func resolve<Service>(_ type: Service.Type) -> Service? {
            let sDescribing = String(describing: type.self)
            let isResolved = factoryDict.keys.filter({ $0 == sDescribing }).count == 1
            if !isResolved {
                Common_Logs.info("Will fail resolving [\(type)] using [\(factoryDict.keys)]")
            }
            let block = factoryDict[sDescribing]
            return block?() as? Service
        }
    }

    @propertyWrapper
    struct Inject<T> {
        var type: T
        public init() {
            self.type = Container.shared.resolve(T.self)!
        }
        public var wrappedValue: T {
            get { return self.type }
            mutating set { self.type = newValue }
        }
    }
}

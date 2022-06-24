//
//  Created by Santos, Ricardo Patricio dos  on 08/06/2021.
//

import Foundation
import Combine
import SwiftUI
import UIKit

extension CommonNameSpace {
    
    /// Helper class to publish changes on "objects"
    public class GenericChangesPublisher {
        public var publisher: AnyPublisher<PublisherOutput, Never> { subject.eraseToAnyPublisher() }
        private let subject = PassthroughSubject<PublisherOutput, Never>()
        public init() { }

    }
}

extension CommonNameSpace.GenericChangesPublisher {
    
    public typealias PublisherOutput = (instanceClass: String, instanceId: String, propName: String, propValue: Any?, date: Date)
    public func emit(_ instanceClass: String, _ instanceId: String, _ propName: String, _ propValue: Any?) {
        subject.send((instanceClass, instanceId, propName, propValue, Date()))
    }
    
}

extension CommonNameSpace.GenericChangesPublisher: Equatable, Hashable {
    
        public static func == (lhs: GenericChangesPublisher,
                               rhs: GenericChangesPublisher) -> Bool {
            return true
        }
        public func hash(into hasher: inout Hasher) { hasher.combine("") }
    
}

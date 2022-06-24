//
//  Created by Ricardo Santos on 07/02/2021.
//

import Foundation
import CoreData

//
// Just use anywere hearn the protocol extension behavior
// Inspired on : https://medium.com/dev-genius/ios-core-data-with-sugar-syntax-ef53a0e06efe
//

public protocol CDataEntityCreatingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension CDataEntityCreatingProtocol {
    public func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

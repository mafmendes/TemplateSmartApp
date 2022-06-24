//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol CDataComposedProtocols: CDataEntityCreatingProtocol,
                                        CDataEntityDeleteSugarProtocol,
                                        CDataEntityFetchSugarProtocol,
                                        CDataEntitySaveSugarProtocol {
    var privateQueue: NSManagedObjectContext { get }
    var mainQueue: NSManagedObjectContext { get }
    func reset()
}

/*
 * https://blog.nfnlabs.in/run-tasks-on-background-thread-swift-5d3aec272140
 *
 * NSMainQueueConcurrencyType is specifically for use with your application interface and can only be used on the main queue of an application.
 * The NSPrivateQueueConcurrencyType configuration creates its own queue upon initialization and can be used only on that queue.
 */

extension CDataComposedProtocols {
    public var privateQueue: NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = viewContext.persistentStoreCoordinator
        return managedObjectContext
    }

    public var mainQueue: NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = viewContext.persistentStoreCoordinator
        return managedObjectContext
    }
}

extension CDataComposedProtocols {
    public func reset() {
        viewContext.reset()
    }
}

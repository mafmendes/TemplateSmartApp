//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

//
// https://codeburst.io/how-to-use-nsfetchedresultscontroller-with-swiftui-de5b75f1b8d0
// How to use NSFetchedResultsController with SwiftUI
//

public extension RJSCDataNameSpace.NonFRP {
    class CDataStoreManager: CDataComposedProtocols {

        // MARK: - Properties

        private let name: String
        private let writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        private let managedObjectModel: NSManagedObjectModel!
        
        lazy public var viewContext: NSManagedObjectContext = {
            return self.storeContainer.viewContext
        }()
        
        public lazy var storeContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
            container.loadPersistentStores { (_, error) in
                if let error = error {
                    fatalError("Unresolved error \(error), \(error.localizedDescription)")
                }
            }
            return container
        }()

        // MARK: - Initializers

        public init(name: String, bundle: String) {
            self.managedObjectModel = RJSCDataNameSpace.RJPSCDataStoreUtils.tryManagedObjectModelWith(dbName: name, bundle: bundle)
            self.name = name
            self.writeContext.persistentStoreCoordinator = storeContainer.persistentStoreCoordinator
        }

    }

}

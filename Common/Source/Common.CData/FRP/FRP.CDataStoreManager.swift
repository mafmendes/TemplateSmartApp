import CoreData

public extension RJSCDataNameSpace.FRP {
    class CDataStoreManager: CDataFRPComposedProtocol, CDataComposedProtocols {

        private let container: NSPersistentContainer

        public func newBackgroundContext() -> NSManagedObjectContext {
            container.newBackgroundContext()
        }

        public var viewContext: NSManagedObjectContext {
            container.viewContext
        }

        public convenience init(name: String, in storageType: RJSCDataNameSpace.StorageType = .persistent, bundle: String) {
            guard let managedObjectModel = RJSCDataNameSpace.RJPSCDataStoreUtils.tryManagedObjectModelWith(dbName: name, bundle: bundle) else {
                fatalError("Invalid name or bundle")
            }
            self.init(name: name, in: storageType, managedObjectModel: managedObjectModel)
        }

        public init(name: String, in storageType: RJSCDataNameSpace.StorageType = .persistent, managedObjectModel: NSManagedObjectModel) {
            container = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
            setupFor(storageType: storageType)
            container.loadPersistentStores { (/*storeDescription*/ _, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
    }
}

private extension RJSCDataNameSpace.FRP.CDataStoreManager {
    func setupFor(storageType: RJSCDataNameSpace.StorageType) {
        if storageType  == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.container.persistentStoreDescriptions = [description]
        }
    }
}

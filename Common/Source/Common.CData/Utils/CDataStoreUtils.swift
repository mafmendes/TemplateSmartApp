// Utils

import Foundation
import CoreData

public extension RJSCDataNameSpace {
    struct RJPSCDataStoreUtils {
        private init() { }

        static func tryManagedObjectModelWith(dbName: String, bundle: String) -> NSManagedObjectModel? {
            guard let bundle = Bundle(identifier: bundle),
                  let modelURL = bundle.url(forResource: dbName, withExtension: "momd"),
                  let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                return nil
            }
            return managedObjectModel
        }
    }
}

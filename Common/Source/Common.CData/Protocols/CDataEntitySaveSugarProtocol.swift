//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol CDataEntitySaveSugarProtocol {
    var viewContext: NSManagedObjectContext { get }
    func saveContext ()
}

extension CDataEntitySaveSugarProtocol {
    public func saveContext () {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

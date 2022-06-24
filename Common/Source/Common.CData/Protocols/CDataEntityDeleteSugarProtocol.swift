//
//  Created by Ricardo Santos on 07/02/2021.
//

import Foundation
import CoreData

//
// Just use anywere hearn the protocol extension behavior
// Inspired on : https://medium.com/dev-genius/ios-core-data-with-sugar-syntax-ef53a0e06efe
//

public protocol CDataEntityDeleteSugarProtocol {
    var viewContext: NSManagedObjectContext { get }
    func delete(request: NSFetchRequest<NSFetchRequestResult>)
}

extension CDataEntityDeleteSugarProtocol {
    public func delete(request: NSFetchRequest<NSFetchRequestResult>) {
        do {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            batchDeleteRequest.resultType = .resultTypeCount
            try viewContext.execute(batchDeleteRequest)
        } catch {
            fatalError("Couldnt delete the entities " + error.localizedDescription)
        }
    }
}

//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol CDataFRPEntitySaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher(save action: @escaping FRPCDataStorePublisherAction) -> CDataFRPEntitySavePublisher
    func reset()
}

public extension CDataFRPEntitySaveProtocol {
    func publisher(save action: @escaping FRPCDataStorePublisherAction) -> CDataFRPEntitySavePublisher {
        CDataFRPEntitySavePublisher(action: action, context: viewContext)
    }
}

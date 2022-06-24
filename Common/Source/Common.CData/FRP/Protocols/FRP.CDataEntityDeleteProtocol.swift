//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol CDataFRPEntityDeleteProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> CDataFRPEntityDeletePublisher<T>
}

extension CDataFRPEntityDeleteProtocol {
    public func publisher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> CDataFRPEntityDeletePublisher<T> {
        CDataFRPEntityDeletePublisher(delete: request, context: viewContext)
    }
}

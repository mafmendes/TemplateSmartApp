//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol CDataFRPEntityFetchProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CDataFRPEntityFetchPublisher<T>
}

extension CDataFRPEntityFetchProtocol {
    public func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CDataFRPEntityFetchPublisher<T> {
        CDataFRPEntityFetchPublisher(request: request, context: viewContext)
    }
}

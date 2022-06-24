//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol CDataFRPComposedProtocol: CDataEntityCreatingProtocol,
                                          CDataFRPEntityFetchProtocol,
                                          CDataFRPEntityDeleteProtocol,
                                          CDataFRPEntitySaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    var privateQueue: NSManagedObjectContext { get }
    var mainQueue: NSManagedObjectContext { get }

    func newBackgroundContext() -> NSManagedObjectContext
}

//
//  Created by Ricardo Santos on 28/01/2021.
//

import Foundation
import CoreData

public extension NSManagedObject {
    class var entityName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

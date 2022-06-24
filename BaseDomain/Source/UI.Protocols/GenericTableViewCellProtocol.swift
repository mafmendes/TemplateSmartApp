//
//  Created by Ricardo Santos on 21/01/2021.
//

import Foundation
import UIKit

public protocol GenericTableViewCellProtocol: ReusableCellProtocol {
    var title: String { get set }
    var subTitle: String { get set }
}

public extension GenericTableViewCellProtocol {

}

public protocol ReusableCellProtocol {
    static var reuseIdentifier: String { get }
}

public extension ReusableCellProtocol {
    static var reuseIdentifier: String { return String(describing: self)+".cellIdentifier)" }
}

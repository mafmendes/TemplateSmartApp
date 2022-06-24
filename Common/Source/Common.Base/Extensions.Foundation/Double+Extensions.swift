//
//  Created by Ricardo Santos on 07/03/2021.
//

import Foundation

public extension CommonExtension where Target == Double {
    func rounded(toPlaces places: Int) -> String { target.rounded(toPlaces: places)}
}

//
// Hide the implementation and force the use of the `rjs` alias
//

fileprivate extension Double {

    /// 1.403843.rounded(toPlaces: 2) >> "1.40"
    func rounded(toPlaces places: Int) -> String {
        let divisor = pow(10.0, Double(places))
        var returnValue = "\((self * divisor).rounded() / divisor)"
        if returnValue.split(separator: ".")[1].count == 1 && places > 1 {
            returnValue += "0"
        }
        return returnValue
    }
}

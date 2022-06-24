//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit

public extension NSPredicate {

    static func with(filter: String) -> NSPredicate? {
        let filterEscaped = filter.trim
        guard !filterEscaped.isEmpty else {
            return nil
        }
        // We have something to search...
        var predicates = [NSPredicate]()
        let words = filter.split(by: " ")
        words.forEach { (word) in
            // Search several words
            if !word.isEmpty {
                let subPreficate = NSPredicate(format: "nomeLocalidade contains[cd] %@ OR numCodPostal contains[cd] %@ OR desigPostal contains[cd] %@",
                                               word, word, word)
                predicates.append(subPreficate)
            }
        }
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        let singlePredicate = NSPredicate(format: "nomeLocalidade contains[cd] %@ OR numCodPostal contains[cd] %@ OR desigPostal contains[cd] %@",
                                 filterEscaped, filterEscaped, filterEscaped)
        if predicates.count >= 2 {
            return compoundPredicate
        } else {
            return singlePredicate
        }
    }
}

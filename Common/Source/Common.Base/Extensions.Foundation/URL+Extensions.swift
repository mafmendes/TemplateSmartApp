//
//  Created by Ricardo Santos on 23/02/2021.
//

import Foundation

public extension CommonExtension where Target == URL {
    var fragmentItems: [String: [String]] { target.fragmentItems }
    var queryItems: [String: [String]] { target.queryItems }
    var schemeAndHostURL: URL? { target.schemeAndHostURL }
}

public extension URL {
    private func splitQuery(_ query: String) -> [String: [String]] {
        return query
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce(into: [String: [String]]()) { result, element in
            guard !element.isEmpty,
                let key = element[0].removingPercentEncoding,
                let value = element.count >= 2 ? element[1].removingPercentEncoding : "" else { return }
            var values = result[key, default: [String]()]
            values.append(value)
            result[key] = values
        }
    }

    var fragmentItems: [String: [String]] {
        guard let fragment = fragment else {
            return [:]
        }
        return splitQuery(fragment)
    }

    var queryItems: [String: [String]] {
        guard let query = query else {
            return [:]
        }
        return splitQuery(query)
    }

    var schemeAndHostURL: URL? {
        guard let scheme = scheme, let host = host else { return nil }
        return URL(string: scheme + "://" + host)
    }
}

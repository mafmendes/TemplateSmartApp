//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation

// swiftlint:disable logs_rule_1

public extension URLRequest {

    static func with(urlString: String,
                     httpMethod: String,
                     httpBody: [String: Any]?,
                     headerValues: [String: String]?) -> URLRequest? {
        guard let theURL = URL(string: "\(urlString)") else {
            Common_Logs.warning("Invalid url [\(urlString)]")
            return nil
        }
        var request = URLRequest(url: theURL)
        request.httpMethod = httpMethod.uppercased()

        if let httpBody = httpBody {
            request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }

        headerValues?.forEach({ (kv) in
            request.addValue(kv.value, forHTTPHeaderField: kv.key)
        })

        return request
    }
}

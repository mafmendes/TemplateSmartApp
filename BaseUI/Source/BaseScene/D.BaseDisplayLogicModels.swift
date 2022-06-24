//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import Common

public struct BaseDisplayLogicModels {

    public struct Warning {
        public let title: String
        public let message: String
        public let devMessage: String
        public var shouldDisplay: Bool = true

        public init(title: String, message: String="", devMessage: String="") {
            self.title = title
            self.message = message
            self.devMessage = devMessage
        }
    }

    public struct Error {
        public let title: String
        public let message: String
        public let devMessage: String
        public var shouldDisplay: Bool = true

        public init(title: String, message: String="", devMessage: String="") {
            self.title = title
            self.message = message
            self.devMessage = devMessage
        }
    }

    public struct Status {
        public let title: String
        public let message: String
        public let devMessage: String
        public init(title: String="", message: String="", devMessage: String="") {
            self.title = title
            self.message = message
            self.devMessage = devMessage
        }
    }

    public struct Loading: Identifiable {
        public let isLoading: Bool
        public let message: String
        public let id: String
        public let sender: String     // Auxiliar for debug
        public let devMessage: String // Auxiliar for debug

        public init(isLoading: Bool, message: String = "", id: String = "",
                    file: String = #file, function: String = #function, line: Int = #line, // Auxiliar for debug
                    devMessage: String // Auxiliar for debug
        ) {
            self.isLoading = isLoading
            self.message = message
            self.id = id
            self.sender = Common_Utils.senderCodeId(function, file: file, line: line)
            self.devMessage = devMessage
        }
    }
}

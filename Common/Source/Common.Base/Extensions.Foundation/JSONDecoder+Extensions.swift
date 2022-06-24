//
//  Created by Ricardo Santos on 22/06/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

// swiftlint:disable logs_rule_1

public extension CommonNameSpace {

    struct WrapEncodable<T: Encodable>: Encodable {
        public let t: T
        public init(t: T) {
            self.t = t
        }
    }

    struct WrapDecodable<T: Decodable>: Decodable {
        public let t: T
        public init(t: T) {
            self.t = t
        }
    }

    enum JSONDecoderErrors: Error {
        case decodeFail
    }

    func perfectMapperThrows<A: Encodable, B: Decodable>(inValue: A, outValue: B.Type) throws -> B {
        do {
            let encoded = try JSONEncoder().encode(inValue)
            let decoded = try JSONDecoder().decodeFriendly(((B).self), from: encoded)
            return decoded
        } catch {
            throw error
        }
    }

    func perfectMapper<A: Encodable, B: Decodable>(inValue: A, outValue: B.Type) -> B? {
        do {
            return try perfectMapperThrows(inValue: inValue, outValue: outValue)
        } catch {
            return nil
        }
    }
}

//
// MARK: - Safe decoder
//

public extension JSONDecoder {

    // Decoder that when fails log as much information as possible for a fast correction/debug
    // swiftlint:disable function_body_length
    func decodeFriendly<T: Decodable>(_ type: T.Type, from data: Data, printError: Bool = true) throws -> T {
        do {
            let result = try JSONDecoder().decode(type, from: data)
            return result
        } catch {
            var debugMessage = "# Fail decoding data into [\(type)]"
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case DecodingError.dataCorrupted(let context):
                    debugMessage = """
                    \(debugMessage)
                    # context = \(context.debugDescription)
                    # context.codingPathList = \(context.codingPath.debugDescription)
                    """
                case DecodingError.keyNotFound(let codingKey, let context):
                    debugMessage = """
                    \(debugMessage)
                    # codingKey = \(codingKey.debugDescription)
                    # context = \(context.debugDescription)
                    # context.codingPathList = \(context.codingPath.debugDescription)
                    """
                case DecodingError.typeMismatch(let propertyType, let context):
                    debugMessage = """
                    \(debugMessage)
                    # type = \(String(describing: propertyType.self))
                    # context = \(context.debugDescription)
                    # context.codingPathList = \(context.codingPath.debugDescription)
                    """
                case DecodingError.valueNotFound(let propertyType, let context):
                    debugMessage = """
                    \(debugMessage)
                    # type = \(String(describing: propertyType.self))
                    # context = \(context.debugDescription)
                    # context.codingPathList = \(context.codingPath.debugDescription)
                    """
                default:
                    break
                }
            }
            if let object = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let json = object as? [String: Any] {
                    debugMessage = "\(debugMessage)# Data contains a single object\n"
                    debugMessage = "\(debugMessage)# \(json)\n"
                } else if let jsonArray = object as? [[String: Any]] {
                    debugMessage = "\(debugMessage)# Data contains an array\n"
                    debugMessage = "\(debugMessage)# \(jsonArray.prefix(5))\n"
                } else {
                    debugMessage = "\(debugMessage)# Not predicted"
                }
            } else {
                debugMessage = "\(debugMessage)# Data does not look JSON"
                debugMessage = "\(debugMessage)# \(String(decoding: data, as: UTF8.self))"
            }
            debugMessage = "\(debugMessage)# \(error.localizedDescription)"
            debugMessage = "\(debugMessage)# \(error)"
            if printError {
                Common_Logs.error("\(debugMessage)")
            }
            throw error
        }
    }
    // swiftlint:enable function_body_length

    private func decodeSafe<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        // https://bugs.swift.org/browse/SR-6163 - Encode/Decode not possible < iOS 13 for top-level fragments (enum, int, string, etc.).
        if #available(iOS 13.0, *) {
            return try JSONDecoder().decodeFriendly(type, from: data)
        } else {
            if let value = try? JSONDecoder().decodeFriendly(type, from: data) {
                return value
            }
            if let value = try? JSONDecoder().decodeFriendly(CommonNameSpace.WrapDecodable<T>.self, from: data) {
                return value.t
            }
            throw CommonNameSpace.JSONDecoderErrors.decodeFail
        }
    }
}

//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import CommonCrypto
import UIKit
//
import Common

public extension DevTools {
    
    enum UserDefaultsKeys: String {
        case storedUserName = "smart.dev_username"
        case storedPassword = "smart.dev_password"
        static var customKeysPrefix: String { "smart.dev_" }
    }
    
    struct UserDefaultsSecure {
        private static func toSecretV1(_ value: String?) -> String? { value?.base64Encoded }
        private static func fromSecretV1(_ value: String?) -> String? { value?.base64Decoded }
        private static func toSecretV2(_ value: String?) -> String? { DevTools.Crypto.encrypt(secret: value).base64Encoded }
        private static func fromSecretV2(_ value: String?) -> String? { DevTools.Crypto.decrypt(base64Encoded: value) }
        
        // Fail safe storage (if encription fails)
        public static func toSecret(value: String?) -> String? {
            if DevTools.Crypto.test(secret: value) {
                return toSecretV2(value)
            } else {
                return toSecretV1(value)
            }
        }
        
        // Fail safe storage (if encription fails)
        public static func fromSecret(value: String?) -> String? {
            if let value = fromSecretV2(value) { return value }
            if let value = fromSecretV1(value) { return value }
            return nil
        }
        
    }
    
    struct UserDefaultsSugar {
        
        private init() { }

        static func valueFor(key: UserDefaultsKeys) -> String? {
            return UserDefaults.standard.string(forKey: key.rawValue)
        }
        
        static func setValueFor(value: Any?, for key: UserDefaultsKeys) {
            UserDefaults.standard.setValue(value, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }
                
        public static var storedPassword: String? {
            get { valueFor(key: .storedPassword) }
            set { setValueFor(value: newValue, for: .storedPassword) }
        }
        
        public static var storedUserName: String? {
            get { valueFor(key: .storedUserName) }
            set { setValueFor(value: newValue, for: .storedUserName) }
        }
    }
}

//
// https://medium.com/@eneko/aes256-cbc-file-encryption-from-the-command-line-with-swift-cd1f88f2e1ec
//
public extension DevTools {
    struct Crypto {
        
        public enum CryptoError: Swift.Error {
            case encryptionError(status: CCCryptorStatus)
            case decryptionError(status: CCCryptorStatus)
            case keyDerivationError(status: CCCryptorStatus)
        }
        
        public static func encrypt(data: Data, key: Data, iv: Data) throws -> Data {
            // Output buffer (with padding)
            let outputLength = data.count + kCCBlockSizeAES128
            // swiftlint:disable syntactic_sugar
            var outputBuffer = Array<UInt8>(repeating: 0, count: outputLength)
            // swiftlint:enable syntactic_sugar
            var numBytesEncrypted = 0
            let status = CCCrypt(CCOperation(kCCEncrypt),
                                 CCAlgorithm(kCCAlgorithmAES),
                                 CCOptions(kCCOptionPKCS7Padding),
                                 Array(key),
                                 kCCKeySizeAES256,
                                 Array(iv),
                                 Array(data),
                                 data.count,
                                 &outputBuffer,
                                 outputLength,
                                 &numBytesEncrypted)
            guard status == kCCSuccess else {
                throw CryptoError.encryptionError(status: status)
            }
            let outputBytes = iv + outputBuffer.prefix(numBytesEncrypted)
            return Data(outputBytes)
        }
        
        public static func decrypt(data cipherData: Data, key: Data) throws -> Data {
            // Split IV and cipher text
            let iv = cipherData.prefix(kCCBlockSizeAES128)
            let cipherTextBytes = cipherData.suffix(from: kCCBlockSizeAES128)
            let cipherTextLength = cipherTextBytes.count
            // Output buffer
            // swiftlint:disable syntactic_sugar
            var outputBuffer = Array<UInt8>(repeating: 0,
                                            count: cipherTextLength)
            // swiftlint:enable syntactic_sugar
            var numBytesDecrypted = 0
            let status = CCCrypt(CCOperation(kCCDecrypt),
                                 CCAlgorithm(kCCAlgorithmAES),
                                 CCOptions(kCCOptionPKCS7Padding),
                                 Array(key),
                                 kCCKeySizeAES256,
                                 Array(iv),
                                 Array(cipherTextBytes),
                                 cipherTextLength,
                                 &outputBuffer,
                                 cipherTextLength,
                                 &numBytesDecrypted)
            guard status == kCCSuccess else {
                throw CryptoError.decryptionError(status: status)
            }
            // Discard padding
            let outputBytes = outputBuffer.prefix(numBytesDecrypted)
            return Data(outputBytes)
        }
        
        public static func derivateKey(passphrase: String, salt: String) throws -> Data {
            let rounds = UInt32(45_000)
            // swiftlint:disable syntactic_sugar
            var outputBytes = Array<UInt8>(repeating: 0, count: kCCKeySizeAES256)
            // swiftlint:enable syntactic_sugar
            let status = CCKeyDerivationPBKDF(
                CCPBKDFAlgorithm(kCCPBKDF2),
                passphrase,
                passphrase.utf8.count,
                salt,
                salt.utf8.count,
                CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
                rounds,
                &outputBytes,
                kCCKeySizeAES256)
            
            guard status == kCCSuccess else {
                throw CryptoError.keyDerivationError(status: status)
            }
            return Data(outputBytes)
        }
        
        static var key: Data? {
            return try? derivateKey(passphrase: "&c3nch#IxX$h9u#V", salt: "rhBnK&&0KpiWOSCl")
        }
        
        static var iv: Data {
            Data([1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6])
        }
        
        public static func encrypt(secret: String?) -> (data: Data?, base64Encoded: String?) {
            guard let key = key, let secret = secret else { return (nil, nil) }
            if let ciphered = try? encrypt(data: Data(secret.utf8), key: key, iv: iv) {
                return (data: ciphered, base64Encoded: ciphered.base64EncodedString())
            }
            return (nil, nil)
        }
        
        public static func decrypt(base64Encoded: String?) -> String? {
            guard let key = key, let base64Encoded = base64Encoded else { return nil }
            let input2 = Data(base64Encoded: base64Encoded)
            if let plainData = try? decrypt(data: input2!, key: key) {
                return String(data: plainData, encoding: .utf8)
            }
            return nil
        }
        
        public static func test(secret: String?) -> Bool {
            guard let key = key, let secret = secret else { return false }
            let input = Data(secret.utf8)
            if let ciphertext = try? encrypt(data: input, key: key, iv: iv),
                let plain = try? decrypt(data: ciphertext, key: key) {
                let c1 = plain == input
                let c2 = String(data: plain, encoding: .utf8) == secret
                let encryptedString = encrypt(secret: secret)
                let decryptedString = decrypt(base64Encoded: encryptedString.base64Encoded!)
                let c3 = decryptedString == secret
                let result = c1 && c2 && c3 // true
                return result
            }
            return false
        }
    }
    
}

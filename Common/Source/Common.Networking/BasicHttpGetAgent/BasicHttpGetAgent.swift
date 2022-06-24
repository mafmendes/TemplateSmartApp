//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
extension NetworkinNameSpace {

    public struct BasicHttpGetAgent {

        private init() {}

        public enum CachePolicy: Int {
            case none        // Dont use cache
            case cold        // Use cache, stored and persistent after app is closed (slow access)
            case hot         // Use cache, persistent only while app is open (fast access)
            case hotElseCold // Use cache, hot first if available, else cold cache
        }

        private static var _imagesCache = NSCache<NSString, UIImage>()
        public static func imageFrom(_ imageURL: String, caching: CachePolicy = .hot, completion: @escaping ((UIImage?) -> Void)) {

            func returnImage(_ image: UIImage?) {
                DispatchQueue.main.async { completion(image) }
            }
            guard let url = URL(string: imageURL) else {
                returnImage(nil)
                return
            }
            let cachedImageName = "cached_image_" + Data(imageURL.utf8).base64EncodedString().self.replacingOccurrences(of: "=", with: "") + ".png"

            if (caching == .hot || caching == .hotElseCold),
               let cachedImage = _imagesCache.object(forKey: cachedImageName as NSString) {
                // Try hot cache first, is faster
                returnImage(cachedImage)
                return
            } else if (caching == .cold || caching == .hotElseCold),
                      let cachedImage = BasicNetworkClientFileManager.imageWith(name: cachedImageName) {
                returnImage(cachedImage)
                return
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                returnImage(image)
                if caching == .cold || caching == .hotElseCold {
                    _ = BasicNetworkClientFileManager.saveImageWith(name: cachedImageName, image: image)
                }
                if caching == .hot || caching == .hotElseCold {
                    _imagesCache.setObject(image, forKey: cachedImageName as NSString)
                }
            }
        }

        /// this function is fetching the json from URL
        public static func dataFrom(urlString: String, completion:@escaping ((Data?, Bool) -> Void)) {
            guard let url = URL(string: urlString) else {
                assertionFailure("Invalid url : \(urlString)")
                completion(nil, false)
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
                guard let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
                    let data = data,
                    error == nil
                    else {
                        assertionFailure("\(String(describing: error))")
                        DispatchQueue.main.async { completion(nil, false) }
                        return
                }
                DispatchQueue.main.async { completion(data, true) }
            }).resume()
        }

        /// Returns in success, Dictionary<String, Any> or [Dictionary<String, Any>]
        public static func JSONFrom(urlString: String, completion: @escaping ((AnyObject?, Bool) -> Void)) {
            dataFrom(urlString: urlString) { (data, success) in
                guard success else {
                    completion(nil, success)
                    return
                }
                if let object = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    if let json = object as? [String: Any] {
                        completion(json as AnyObject, true)
                    } else if let jsonArray = object as? [[String: Any]] {
                        completion(jsonArray as AnyObject, true)
                    } else { completion(nil, false) }
                } else { completion(nil, false) }
            }
        }
    }
}

fileprivate extension Common_BasicHttpGetAgent {

    struct BasicNetworkClientFileManager {
        static var destinyFolder: String {
            let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            return documentsDirectory as String
        }

        static func imageWith(name: String) -> UIImage? {
            guard !name.isEmpty else { return nil }
            let path = destinyFolder + "/" + name.replacingOccurrences(of: "\\", with: "/")
            return UIImage(contentsOfFile: path)
        }

        static func saveImageWith(name: String, image: UIImage) -> Bool {
            guard !name.isEmpty else { return false }
            let path = destinyFolder + "/" + name.replacingOccurrences(of: "\\", with: "/")
            if let data = image.pngData() {
                return (try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
            }
            return false
        }
    }
}

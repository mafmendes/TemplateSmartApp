//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

//
// MARK :- Collection
//

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}

//
// MARK :- Array
//

public extension Array {

    mutating func shuffle() {
        for _ in 0...count {
            sort { (_, _) in arc4random() < arc4random() }
        }
    }

    private func safeItem(at index: Int) -> Element? {
        guard index >= 0 else { return nil }
        return Int(index) < count ? self[Int(index)] : nil
    }

    // Safe get item at index
    func item(at index: Int) -> Element? {
        safeItem(at: index)
    }

    func element(at index: Int) -> Element? {
        safeItem(at: index)
    }

    subscript(indexPath: IndexPath) -> Element? {
        safeItem(at: indexPath.row)
    }

    func take(_ k: Int) -> Array {
        let min = Swift.min(k, count)
        return Array(self[0..<min])
    }

    func skip(_ k: Int) -> Array {
        return Array(dropFirst(k))
    }

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    var randomItem: Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}

public extension Array where Element: Hashable {

    var set: Set<Element> {
        return Set(self)
    }

    /// Taken from here: https://stackoverflow.com/a/46354989/491239
    static func removeDuplicates(_ elements: [Element]) -> [Element] {
        var seen = Set<Element>()
        return elements.filter { seen.insert($0).inserted }
    }
    
}

public extension RangeReplaceableCollection where Iterator.Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object: Iterator.Element) {
        self = filter { return $0 != object }
    }
}

//
//  Created by Ricardo Santos on 29/01/2021.
//

import Foundation
import UIKit

public func synced<T>(_ lock: Any, closure: () -> T) -> T {
    objc_sync_enter(lock)
    let r = closure()
    objc_sync_exit(lock)
    return r
}

// Screen width.
public var screenWidth: CGFloat {
    screenSize.width
}

// Screen height.
public var screenHeight: CGFloat {
    screenSize.height
}

public var screenSize: CGSize {
    UIScreen.main.bounds.size
}

/// Normalise a value `valueValueRangeA` on range `[startRangeA, endRangeA]` into range `[startRangeB, endRangeB]` range
public func normalizeFromRangeAToRangeB(valueValueRangeA: CGFloat,
                                        startRangeA: CGFloat,
                                        endRangeA: CGFloat,
                                        startRangeB: CGFloat,
                                        endRangeB: CGFloat) -> CGFloat {
    return CGFloat(startRangeB + ((valueValueRangeA - startRangeA) * (endRangeB - startRangeB)) / (endRangeA - startRangeA))
}

/// Roud to clossets value multiple of 10
public func roundToClosestMultipleOf10(n: Int) -> Int {
    let a = (n / 10) * 10 // Smaller multiple
    let b = a + 10        // Larger multiple
    let winner = (n - a > b - n) ? b : a // Return of closest of two
    return winner
}

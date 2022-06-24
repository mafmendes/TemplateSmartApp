//
//  Created by Ricardo Santos on 17/01/2021.
//

import Foundation
import UIKit

// swiftlint:disable identifier_name

extension AppConstantsNameSpace {
    
    public enum SizesNames: Int, Codable, CaseIterable {
        
        case size_1 = 2   // Preferred
        case size_2 = 4
        case size_3 = 8   // Unit
        case size_4 = 16  // Base
        case size_5 = 24
        case size_6 = 32  // Preferred
        case size_7 = 40
        case size_8 = 48
        case size_9 = 56
        case size_10 = 64 // Preferred
        case size_11 = 72
        case size_12 = 80
        case size_13 = 88
        case size_14 = 96
        case size_15 = 104
        case size_16 = 112
        case size_17 = 120
        case size_18 = 128
        case size_19 = 136
        case size_20 = 144
        case size_21 = 152
        case size_22 = 160
        case size_23 = 168
        case size_24 = 174
        case size_25 = 184
        case size_26 = 192
        case size_27 = 200
        case size_28 = 208
        case size_29 = 216
        case size_30 = 224
        case size_31 = 232
        case size_32 = 240
        case size_33 = 248
        case size_34 = 256
        case size_35 = 264
        case size_36 = 272
        case size_37 = 280
        case size_38 = 288
        case size_39 = 296
        case size_40 = 304
        case size_41 = 308
        case size_42 = 316
        case size_43 = 324
        case size_44 = 332
        case size_45 = 340
        case size_46 = 348
        case size_47 = 356
        case size_48 = 364
        case size_49 = 372
        case size_50 = 380
        case size_51 = 388
        case size_52 = 396
        case size_53 = 404
        case size_54 = 408
        case size_55 = 512
        case size_56 = 520
        case size_57 = 528
        case size_58 = 536
        case size_59 = 664
        
        public static var defaultMargin: CGFloat { size_5.cgFloat }
        
        public var intValue: Int {
            return Int(rawValue)
        }
        
        public var cgFloat: CGFloat {
            return CGFloat(rawValue)
        }
    }

}

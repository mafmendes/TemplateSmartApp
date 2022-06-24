//
//  Created by Ricardo Santos
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

public extension Image {
    func contentMode(_ mode: ContentMode) -> some View {
        resizable().aspectRatio(contentMode: mode)
    }

    func tint(color: Color) -> some View {
        foregroundColor(color)
    }

    func resize(width: CGFloat, height: CGFloat, alignment: Alignment = .center) -> some View {
        resizable().frame(width: width, height: height, alignment: alignment)
    }
    
    func resize(size: CGSize, alignment: Alignment = .center) -> some View {
        resizable().frame(width: size.width, height: size.height, alignment: alignment)
    }
}

public enum ImageSFSymbol: String, CaseIterable {
    case arrow
    case arrow2 = "arrow.2"
    case arrowCounterClockWise = "arrow.counterclockwise"
    case arrowClockWise = "arrow.clockwise"
    case app
    case bag
    case bell
    case bolt
    case bubble
    case cloud
    case clock
    case camera
    case chevron
    case circle
    case car
    case envelope
    case ellipsis
    case flame
    case key
    case house
    case heart
    case gear
    case lock
    case location
    case magnifyingglass
    case message
    case minus
    case minusSquare = "minus.square"
    case minusCircle = "minus.circle"
    case multiplyCircle = "multiply.circle"
    case mic
    case micCircle = "mic.circle"
    case micSlash = "mic.slash"
    case phone
    case paperplane
    case person
    case personCrop = "person.crop"
    case personCropCircle = "person.crop.circle"
    case personCropSquare = "person.crop.square"
    case plus
    case pause
    case play
    case plusCircle = "plus.circle"
    case plusSquare = "plus.square"
    case star
    case sparkles
    case stop
    case thermometer
    case square
    case squareAndArrow = "square.and.arrow"
    case wifi
    case xmark
}

public extension ImageSFSymbol {
    var name: String {
        self.rawValue
    }

    // swiftlint:disable no_hardCodedImages
    
    var uiImage: UIImage {
        if let image = UIImage(systemName: "\(rawValue)") {
            return image
        } else {
            return UIImage()
        }
    }
    
    var image: Image {
        Image(systemName: "\(rawValue)")
    }

    var imageFill: Image {
        Image(systemName: "\(rawValue).fill")
    }

    var imageBadge: Image {
        Image(systemName: "\(rawValue).badge")
    }

    var imageSquarePath: Image {
        Image(systemName: "\(rawValue).squarepath")
    }

    var imageSquare: Image {
        Image(systemName: "\(rawValue).square")
    }

    var imageCircle: Image {
        Image(systemName: "\(rawValue).circle")
    }

    var imageRight: Image {
        Image(systemName: "\(rawValue).right")
    }

    var imageLeft: Image {
        Image(systemName: "\(rawValue).left")
    }

    var imageUp: Image {
        Image(systemName: "\(rawValue).up")
    }

    var imageDown: Image {
        Image(systemName: "\(rawValue).down")
    }
    // swiftlint:enable no_hardCodedImages
}

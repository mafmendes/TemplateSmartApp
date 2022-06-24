//
//  Created by Ricardo Santos on 27/02/2021.
//

import Foundation
import Combine
import UIKit

public extension CombineCompatible {
    var touchUpInsidePublisher: AnyPublisher<UIControl, Never> { target.touchUpInsidePublisher }
    var touchDownRepeatPublisher: AnyPublisher<UIControl, Never> { target.touchDownRepeatPublisher }
}

public extension CombineCompatibleProtocol where Self: UIControl {
    var touchUpInsidePublisher: AnyPublisher<Self, Never> {
        CommonNameSpace.UIControlPublisher(control: self,
                                           events: [.touchUpInside]).eraseToAnyPublisher()
    }
    var touchDownRepeatPublisher: AnyPublisher<Self, Never> {
        CommonNameSpace.UIControlPublisher(control: self,
                                           events: [.touchDownRepeat]).eraseToAnyPublisher()
    }
}

// swiftlint:disable no_UIKitAdhocConstruction
fileprivate extension CommonNameSpace {
    func sample() {
        let btn = UIButton()
        _ = btn.publisher(for: .touchUpInside).sinkToReceiveValue { (_) in }
        _ = btn.combine.touchUpInsidePublisher.sinkToReceiveValue { (_) in }
        _ = btn.touchUpInsidePublisher.sinkToReceiveValue { (_) in }

        btn.common.onTouchUpInside { }
        btn.onTouchUpInside { }

        btn.sendActions(for: .touchUpInside)

    }
}
// swiftlint:enable no_UIKitAdhocConstruction

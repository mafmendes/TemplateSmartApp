//
//  Created by Ricardo Santos on 19/02/2021.
//

import Foundation
import Combine
import UIKit

// swiftlint:disable logs_rule_1

public extension CombineCompatible {
    var onTurnedOnPublisher: AnyPublisher<Bool, Never> {
        if let target = target as? UISwitch {
            return target.onTurnedOnPublisher
        } else {
            return AnyPublisher.never()
        }
    }
}

public extension CombineCompatibleProtocol where Self: UISwitch {
    var onTurnedOnPublisher: AnyPublisher<Bool, Never> {
        CommonNameSpace.UIControlPublisher(control: self, events: [.allEditingEvents, .valueChanged]).map { $0.isOn }.eraseToAnyPublisher()
    }
}

// swiftlint:disable no_UIKitAdhocConstruction
fileprivate extension CommonNameSpace {
    func sample() {
        let switcher = UISwitch()
        switcher.isOn = false
        let submitButton = UIButton()
        submitButton.isEnabled = false

        _ = switcher.onTurnedOnPublisher.assign(to: \.isEnabled, on: submitButton)
        _ = switcher.combine.onTurnedOnPublisher.assign(to: \.isEnabled, on: submitButton)

        switcher.isOn = true
        switcher.sendActions(for: .valueChanged)
        Common_Logs.info(submitButton.isEnabled)
    }
}
// swiftlint:enable all

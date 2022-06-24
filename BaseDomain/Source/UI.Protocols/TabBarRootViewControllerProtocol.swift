//
//  Created by Santos, Ricardo Patricio dos  on 02/06/2021.
//

import Foundation

/// For controller that are tab bar base controllers
public protocol TabBarRootViewControllerProtocol {
    func performSoftReLoad(_ completion:() -> Void)
    func performHardReLoad(_ completion:() -> Void)
}

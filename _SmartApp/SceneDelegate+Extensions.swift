//
//  Created by Ricardo Santos on 14/01/2021.
//

import UIKit
import Foundation
import Combine
import SwiftUI
//
import BaseUI
import Common
import Designables
import Resources
import DevTools
import AppConstants

extension SceneDelegate {

    static var rootViewController: UIViewController = {
        tabBarController
    }()
    
    /// App `UITabBarController`
    static var tabBarController: VC.TabBarController = {
        VC.TabBarController()
    }()
    
}

//
//  Created by Ricardo Santos on 14/01/2021.
//

import UIKit
import Combine
import UserNotifications
//
import Swinject
//
import AppCore
import Common
import AppDomain
import BaseDomain
import Resources
import DevTools

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let cancelBag = CancelBag()
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppSetup.shared.setup()
          
        return true
    }
    
    //
    // MARK: Push Notifications
    //
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
                
        DevTools.Log.debug("Device Token: \(token)", .pushNotifications) //3
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DevTools.Log.debug("Failed to register: \(error)", .pushNotifications) //3
    }
}

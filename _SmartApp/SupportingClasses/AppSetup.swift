//
//  Created by Santos, Ricardo Patricio dos  on 02/04/2021.
//

import Foundation
import UIKit
//
import Common
import Resources
import DevTools
import AppCore

#warning("Tutorial: AppSetup - App initial setup (if needed)")

//
// MARK: - AppSetup
//

class AppSetup {
    private init() { }
    static let shared = AppSetup()
    private var cancelBag = CancelBag()
    
    func setup() {
        pushNotificationsSetup()
        DevTools.Log.setup()
        ColorSchemeManager.setup()
        ResourcesNameSpace.setup()
    }
    
    /// Active -> Background/Closed : Parte 1
    func willResignActive() {

    }
    
    /// Active -> Background/Closed : Parte 2
    func didEnterBackground() {

    }
    
    /// Background/Closed -> Active : Parte 1
    func willEnterForeground() {

    }
    
    /// Background/Closed -> Active : Parte 2
    func didBecomeActive() {

    }
    
    // https://www.raywenderlich.com/11395893-push-notifications-tutorial-getting-started
    private func pushNotificationsSetup() {
        guard DevTools.onDevMode else { return }
        
        /**
         1 : UNUserNotificationCenter handles all notification-related activities in the app, including push notifications.
         2 : You invoke requestAuthorization(options:completionHandler:) to (you guessed it) request authorization to show notifications.
         The passed options indicate the types of notifications you want your app to use — here you’re requesting alert, sound and badge.
         3 : The completion handler receives a Bool that indicates whether authorization was successful. In this case, you simply print the result.
         
         .badge: Display a number on the corner of the app’s icon.
         .sound: Play a sound.
         .alert: Display a text notification.
         .carPlay: Display notifications in CarPlay.
         .provisional: Post non-interrupting notifications. The user won’t get a request for permission if you use only this option, but your notifications
         will only show silently in the Notification Center.
         .providesAppNotificationSettings: Indicate that the app has its own UI for notification settings.
         .criticalAlert: Ignore the mute switch and Do Not Disturb. You’ll need a special entitlement from Apple to use this option, because it’s meant only for very special use cases.
         
         4: You’ve added a call to getNotificationSettings() in the completion handler. This is important because the user can, at any time, go into the S
         ettings app and change their notification permissions. The guard avoids making this call in cases where permission wasn’t granted.
         */
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert]) { granted, _ in // 2
                DevTools.Log.debug("Permission granted: \(granted)", .pushNotifications) // 3
                guard granted else { return } // 4
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DevTools.Log.debug("Notification settings: \(settings)", .pushNotifications) // 4
                    guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
    }
    
}

//
// MARK: - ColorSchemeManager
//

private class ColorSchemeManager {
    private init() { }
    
    static func setup() {
        
    }
}

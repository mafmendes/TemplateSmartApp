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

#if canImport(SwiftUI) && DEBUG
private struct PRootViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        SceneDelegate.rootViewController.asAnyView.buildPreviews(full: true)
    }
}
#endif

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var mainWindow: UIWindow?
    static private (set) var appCoordinator: C.AppMainCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                    
        let appCoordinator = C.AppMainCoordinator(window: UIWindow(windowScene: windowScene))
        appCoordinator.start()
        Self.appCoordinator = appCoordinator
    }
    
    /// Active -> Background/Closed : Parte 1
    /// Tells the delegate that the scene is about to resign the active state and stop responding to user events.
    func sceneWillResignActive(_ scene: UIScene) {
        AppSetup.shared.willResignActive()
    }
    
    /// Active -> Background/Closed : Parte 2
    /// Tells the delegate that the scene is running in the background and is no longer onscreen.
    func sceneDidEnterBackground(_ scene: UIScene) {
        AppSetup.shared.didEnterBackground()
    }
    
    /// Background/Closed -> Active : Parte 1
    /// Tells the delegate that the scene is about to begin running in the foreground and become visible to the user.
    func sceneWillEnterForeground(_ scene: UIScene) {
        AppSetup.shared.willEnterForeground()
    }
    
    /// Background/Closed -> Active : Parte 2
    /// Tells the delegate that the scene became active and is now responding to user events.
    func sceneDidBecomeActive(_ scene: UIScene) {
        AppSetup.shared.didBecomeActive()
    }
}

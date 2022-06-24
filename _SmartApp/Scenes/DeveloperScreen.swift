//
//  Created by Santos, Ricardo Patricio dos  on 09/04/2021.
//

import UIKit
import Foundation
import SwiftUI
import Combine
//
import Designables
import Resources
import DevTools
import BaseUI
import AppConstants
import Common
import WebAPIDomain
import BaseDomain
import AppDomain

struct DeveloperScreen: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body : some View {
        NavigationView {
            List {
                
                Section(header: Text("About App/Device")) {
                    VStack(alignment: .leading) {
                        Text("- Env: [\(DevTools.targetEnv.uppercased())]")
                        Text("- DeviceSize: [\(UIDevice.deviceSize.rawValue)]")
                        Text("- SizeCategory: [\(UIFactory.view().traitCollection.preferredContentSizeCategory.rawValue)]")
                        Text("- Locale.[identifier|calendar]: [\(NSLocale.current.identifier)|\(NSLocale.current.calendar.description)]")
                    }
                }
                
                Section(header: Text("Feature Flags")) {
                    NavigationLink(destination: DevTools_Previews_FeatureFlag.Preview.previews) { Text("Feature Flags") }
                }
                
                #if DEBUG
                Section(header: Text("References")) {
                    NavigationLink(destination: Resources_Preview.PreviewVC().asAnyView) { Text("App Resources") }
                    NavigationLink(destination: UIFactory_Preview.PreviewVC().asAnyView) { Text("App UIFactory") }
                }
                #endif
                
                Section(header: Text("App Screens")) {
                    NavigationLink(destination: VC.___VARIABLE_sceneName___ViewController.instance()?.asAnyView) {
                        Text("Template Screen")
                    }
                    NavigationLink(destination: VC.ZipCodesListViewController.instance(with: nil)?.asAnyView) {
                        Text("Account Settings")
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarHidden(false)
    }
}

extension Previews_DeveloperScreen {
    public static func presentFrom(view: UIView) {
        if let vc = view.common.viewController {
            vc.present(DeveloperScreen().asViewController, animated: true, completion: nil)
        }
    }
}

struct Previews_DeveloperScreen {
    struct Preview: PreviewProvider {
        public static var previews: some View {
            DeveloperScreen().buildPreviews()
        }
    }
}

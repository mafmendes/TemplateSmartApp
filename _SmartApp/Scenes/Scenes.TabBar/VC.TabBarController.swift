//
//  Created by Santos, Ricardo Patricio dos  on 22/04/2021.
//

import UIKit
import Foundation
import SwiftUI
import Combine
//
import Common
import DevTools
import BaseDomain
import AppDomain
import BaseUI
import Designables
import Resources
import AppConstants

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PTabBarControllerPreviews: PreviewProvider {
    static var previews: some View {
        Common_ViewControllerRepresentable {
            let vc = VC.TabBarController()
            vc.doViewWillFirstAppear()
            return vc
        }
        .buildPreviews(full: true)
    }
}
#endif

public extension VC {
        
     class TabBarController: UITabBarController, TabBarViewControllerProtocol {
                
        private (set) var currentlySelectedTab: C.TabBarCoordinator.Action = .tab1WithMeaningfulName
        public var cancelBag = CancelBag()
        
        private lazy var toolBar: V.ToolBar = {
            V.ToolBar()
        }()
        
        public var toolBarStateOutput: GenericObservableObjectForHashable<VM.ToolBar.ViewOutput.Action> {
            toolBar.output
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            setup()
        }
                
        private func setup() {
                        
            toolBar.installOn(view: view)
            toolBarStateOutput.value.sink { [weak self] (some) in
                guard let self = self else { return }
                switch some {
                case .taped(_, id: let id, _):
                    self.display(using: id)
                }
            }.store(in: cancelBag)
            
            // Set Tab hiden
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().clipsToBounds = true

            viewControllers = [C.TabBarCoordinator.Action.tab1WithMeaningfulName.instance,
                               C.TabBarCoordinator.Action.tab2WithMeaningfulName.instance,
                               C.TabBarCoordinator.Action.tab3WithMeaningfulName.instance,
                               C.TabBarCoordinator.Action.tab4WithMeaningfulName.instance]
            
        }
        
        private func display(using accessibilityIdentifier: AccessibilityIdentifier) {
            let tab = C.TabBarCoordinator.Action.with(accessibilityIdentifier: accessibilityIdentifier)
            toolBar.highlightedTab = tab
            display(tab: tab)
        }
        
        func display(tab: C.TabBarCoordinator.Action) {
            let isDoubleTap = tab == currentlySelectedTab // Double tap
            let performSoftReLoad = isDoubleTap
            var performHardReLoad = DevTools.false
            currentlySelectedTab = tab
            selectedIndex = tab.selectedIndex
            
            if performSoftReLoad {
                var performSoftReLoadSucess = false
                if let navigationController = viewControllers![selectedIndex] as? UINavigationController {
                    if let result = navigationController.viewControllers.first as? TabBarRootViewControllerProtocol {
                        result.performSoftReLoad({})
                        performSoftReLoadSucess = true
                    }
                }
                if !performSoftReLoadSucess {
                    DevTools.assert(false, message: "Fail performing soft reload")
                    performHardReLoad = true
                }
            }

            if performHardReLoad {
                viewControllers![selectedIndex] = tab.instance
            }
        
        }
    }
}

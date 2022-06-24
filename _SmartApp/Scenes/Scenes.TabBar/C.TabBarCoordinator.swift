//
//  Created by Santos, Ricardo Patricio dos  on 07/05/2021.
//
import Foundation
import UIKit
import Combine
//
import BaseUI
import Common
import DevTools
import AppDomain

extension C {
    
    class TabBarCoordinator: C.BaseCoordinator, GenericSceneCoordinatorProtocol {
        
        var coordinatorIsCompleted: (() -> Void)?
        var cancelBag: CancelBag = CancelBag()
        private(set) weak var viewController: UIViewController?
        private var viewControllerProtocol: TabBarViewControllerProtocol? {
            if let result = viewController as? TabBarViewControllerProtocol {
                return result
            }
            if let navigationController = viewController as? UINavigationController {
                if let result = navigationController.viewControllers.first as? TabBarViewControllerProtocol {
                    return result
                }
            }
            return nil
        }
        
        init(viewController: UIViewController?) {
            self.viewController = viewController
        }

        override func start() {
            // Insert logic to run before this flow starts
            DevTools.Log.trace("\(Self.self) Coordinator started by [\(SceneDelegate.tabBarController.className)]", .generic)
        }
        
        func perform(_ action: Action) {
            guard let vc = viewControllerProtocol else { return }
            switch action {
            case .dismiss:     ()
            case .tab1WithMeaningfulName:  vc.display(tab: .tab1WithMeaningfulName)
            case .tab2WithMeaningfulName:  vc.display(tab: .tab2WithMeaningfulName)
            case .tab3WithMeaningfulName:  vc.display(tab: .tab3WithMeaningfulName)
            case .tab4WithMeaningfulName: vc.display(tab: .tab4WithMeaningfulName)
            }
        }
    
    }

}

extension C.TabBarCoordinator {
    public enum Action: Hashable, CaseIterable {
        case dismiss
        case tab1WithMeaningfulName
        case tab2WithMeaningfulName
        case tab3WithMeaningfulName
        case tab4WithMeaningfulName
        
        static func with(accessibilityIdentifier: AccessibilityIdentifier) -> C.TabBarCoordinator.Action {
            switch accessibilityIdentifier {
            case .toolBarBtn1WithMeaningfulName: return .tab1WithMeaningfulName
            case .toolBarBtn2WithMeaningfulName: return .tab2WithMeaningfulName
            case .toolBarBtn3WithMeaningfulName: return .tab3WithMeaningfulName
            case .toolBarBtn4WithMeaningfulName: return .tab4WithMeaningfulName
            default: fatalError("Not predicted")
            }
        }
        
        public var accessibilityIdentifier: AccessibilityIdentifier {
            switch self {
            case .tab1WithMeaningfulName: return .toolBarBtn1WithMeaningfulName
            case .tab2WithMeaningfulName: return .toolBarBtn2WithMeaningfulName
            case .tab3WithMeaningfulName: return .toolBarBtn3WithMeaningfulName
            case .tab4WithMeaningfulName: return .toolBarBtn4WithMeaningfulName
            case .dismiss: fatalError("Not predicted")
            }
        }
        
        var selectedIndex: Int {
            switch self {
            case .tab1WithMeaningfulName: return 0
            case .tab2WithMeaningfulName: return 1
            case .tab3WithMeaningfulName: return 2
            case .tab4WithMeaningfulName: return 3
            case .dismiss: return -1
            }
        }
        
        var instance: UIViewController {
            #warning("Tutorial : Return the view controller acording with the pretended tab")
            var viewController: UIViewController!
            switch self {
            case .tab1WithMeaningfulName: viewController = VC.MoviesViewController.instance()//VC.ZipCodesListViewController.instance(with: .none)!
            case .tab2WithMeaningfulName: viewController = VC.___VARIABLE_sceneName___ViewController.instance()
            case .tab3WithMeaningfulName: viewController = VC.ZipCodesListUIViewController.instance()
            case .tab4WithMeaningfulName: viewController = UIViewController()
            case .dismiss: ()
            }
            return viewController.embeddedInNavigationController()
        }
    }
}

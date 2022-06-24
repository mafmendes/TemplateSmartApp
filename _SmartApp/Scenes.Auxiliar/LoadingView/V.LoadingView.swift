//
//  Created by Santos, Ricardo Patricio dos  on 26/04/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
import Combine
import WebKit
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
struct PLoadingVPreviews: PreviewProvider {
    static var previews: some View {
        Common_ViewRepresentable {
            let login = V.LoadingView()
            return login
        }.buildPreviews(full: true)
    }
}
#endif

extension VC {
    public class LoadingViewController: UIViewController {
        private var isDismissing: Bool = true
        func setupWith(loadingView: V.LoadingView) {
            view = loadingView
            view.tag = AppTags.loadingView.tag
            isDismissing = false
        }
        
        func dismiss() {
            guard !isDismissing else { return } // Allready dismissing
            isDismissing = true
            let duration = Common_Constants.defaultAnimationsTime
            view.fadeTo(0, duration: duration)
            Common_Utils.delay(duration) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: false, completion: { })
            }
        }
    }

}

extension V {
    
    public class LoadingView: BaseGenericView,
                              MVVMGenericViewProtocol {
        
        typealias ViewData = String
        typealias ViewOutput = String
        
        var output: CommonNameSpace.GenericObservableObjectForHashable<ViewOutput> = .init()
        var input: MVVMViewInputObservable<ViewData> = .init()
        
        func setupWith(viewModel: ViewData) { }
        func softReLoad() { }
        func handle(stateInput: MVVMViewInput<String>) { }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }
        
        fileprivate let loadingRadius: CGFloat = SizeNames.size_5.cgFloat
        fileprivate lazy var loading: MaterialLoadingIndicator = {
            MaterialLoadingIndicator.default(with: loadingRadius)
        }()
        
        fileprivate lazy var caption: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .na)
        }()
        // MARK: - Mandatory
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        public override func prepareLayoutCreateHierarchy() {
            addSubview(loading)
            addSubview(caption)
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            loading.layouts.centerToSuperview()
            loading.layouts.width(loadingRadius * 2)
            loading.layouts.height(loadingRadius * 2)
                        
            caption.layouts.topToBottom(of: loading, offset: SizeNames.size_3.cgFloat)
            caption.layouts.centerXToSuperview()
            caption.layouts.width(100)
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        public override func prepareLayoutByFinishingPrepareLayout() {
            caption.textAlignment = .center
            caption.numberOfLines = 0
        }
        
        public override func setupColorsAndStyles() {
            backgroundColor = ColorSemantic.backgroundPrimary.uiColor.alpha(0.84)
            caption.applyStyle(.caption1Bold, .labelPrimary)
        }
        
        // This function is called automatically by super BaseGenericView
        public override func setupViewUIRx() {

        }
        
        private static func rootFrom(vc: UIViewController?) -> UIViewController? {
            if let tabBarController = vc?.tabBarController {
                return tabBarController
            } else {
                return vc
            }
        }
        
        private static func current(from: UIViewController?) -> VC.LoadingViewController? {
            let topViewController = rootFrom(vc: from)?.topViewController
            if let loadingViewController = topViewController as? VC.LoadingViewController {
                return loadingViewController
            }
            return nil
        }
        
        public static func presentOver(_ viewController: UIViewController?, message: String?, id: String) {
            guard current(from: viewController) == nil else {
                // Allready loading!
                if let current = current(from: viewController) {
                    if let loadingView = current.view as? V.LoadingView {
                        loadingView.caption.textAnimated = message ?? ""
                    }
                }
                return
            }
            let loadingViewController = VC.LoadingViewController()
            let loadingView = V.LoadingView()
            loadingView.caption.text = message ?? ""
            loadingView.alpha = 0
            loadingViewController.setupWith(loadingView: loadingView)
            loadingViewController.modalPresentationStyle = .overCurrentContext
            
            rootFrom(vc: viewController)?.present(loadingViewController,
                                                  animated: false,
                                                  completion: {
                loadingViewController.view.fadeTo(1)
            })
        }
        
        public static func dismiss(from: UIViewController?) {
            guard let current = current(from: from) else {
                // nothing to do
                return
            }
            current.dismiss()
        }
        
    }
}

// MARK: - Private

private extension V.LoadingView {

}

// MARK: - setupWith(viewModel: ViewData)

extension V.LoadingView {
    
}

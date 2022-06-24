//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
//
import Common

open class BaseGenericViewController<T: StylableView>: BaseViewController {

    public var cancelBag = CancelBag()
    deinit {
        if genericView != nil {
            genericView.removeFromSuperview()
        }
    }

    public var genericView: T!

    public init() {
        super.init(nibName: nil, bundle: nil)
        setupGenericView()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGenericView() {
        guard genericView == nil else {
            // Allready setup
            return
        }
        genericView = T()
        view.addSubview(genericView)
        if let baseGenericView = genericView as? BaseGenericView {
            // We must call the LifeCicle only AFTER the generic view is added on the view due
            // this issue : https://stackoverflow.com/questions/30969353/what-is-uitemporarylayoutwidth-and-why-does-it-break-my-constraints
            baseGenericView.doViewLifeCycle()
        }
        genericView.edgesToSuperview(usingSafeArea: false)
        rxSetup()
        view.accessibilityIdentifier = genericAccessibilityIdentifier
    }

    open override func loadView() {
        super.loadView()
        // Setup Generic View
        setupGenericView()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColorsAndStyles() // For the view controller
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViewIfNeed()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUIRx()
    }

    open func setupViewIfNeed() {
        fatalError("Override me")
    }

    open func setupNavigationUIRx() {
        fatalError("Override me")
    }

    open func rxSetup() {
        fatalError("Override me")
    }

}

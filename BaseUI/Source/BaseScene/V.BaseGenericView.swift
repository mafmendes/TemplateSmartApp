//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
import Combine
//
//import Toast
//
import Common
import BaseDomain
import DevTools
import AppConstants

// MARK: - BaseGenericView
open class BaseGenericView: StylableView {

    public var cancelBag = CancelBag()
    private var viewLifeCycleWasPerfomed = false
    private var onPerformingLayoutIfNeeded = false
    public init() {
        super.init(frame: .zero)
        doViewLifeCycle()
    }
    
    public var asView: UIView {
        self as UIView
    }
    
    public var viewController: UIViewController? {
        asView.common.viewController
    }
    
    /// Fixing iOS15 truncated texts and broken overlays
    public func performLayoutIfNeeded(animated: Bool = true) {
        let duration = AppConstants.TimeIntervals.defaultAnimationDuration
        guard !onPerformingLayoutIfNeeded else {
            Common_Utils.delay(duration * 1.1) { [weak self] in
                self?.performLayoutIfNeeded()
            }
            return
        }
        onPerformingLayoutIfNeeded = true
        Common_Utils.executeInMainTread { [weak self] in
            guard let self = self else { return }
            _ = self.allSubviews.map({
                $0.setNeedsUpdateConstraints() // will update the constraints that will be changed based on a change you have made. Fix truncated text fields
            })
            let setNeedsLayoutWork = { [weak self] in
                _ = self?.allSubviews.map({
                    $0.setNeedsLayout() // Marks the view for redrawing and putting it inside animation block makes the drawing animated. Fix components overlayed
                })
                self?.onPerformingLayoutIfNeeded = false
            }
            if animated {
                UIView.animate(withDuration: duration) {
                    setNeedsLayoutWork()
                }
            } else {
                setNeedsLayoutWork()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        doViewLifeCycle()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        doViewLifeCycle()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        // The reason of [doViewLifeCycle] is: If we create a new hadhoc generic view like on
        //  -->> lazy var barView: BarView = { BarView() }() <<--
        // On layoutSubviews is were we retry to do view life cicle (since we can only do it
        // after a view have a super view due to the issue
        // https://stackoverflow.com/questions/30969353/what-is-uitemporarylayoutwidth-and-why-does-it-break-my-constraints
        doViewLifeCycle()
        didLayoutSubviews()
    }
    
    func doViewLifeCycle() {
        guard self.superview != nil && !viewLifeCycleWasPerfomed else {
            // We cant call doViewLifeCycle until the view has a super view
            // due to this issue : https://stackoverflow.com/questions/30969353/what-is-uitemporarylayoutwidth-and-why-does-it-break-my-constraints
            return
        }
        viewLifeCycleWasPerfomed = true
        prepareLayoutCreateHierarchy()           // DONT CHANGE ORDER
        prepareLayoutBySettingAutoLayoutsRules() // DONT CHANGE ORDER
        prepareLayoutByFinishingPrepareLayout()  // DONT CHANGE ORDER
        setupViewUIRx()                          // DONT CHANGE ORDER
        setupColorsAndStyles()

    }

    open func didLayoutSubviews() {

    }
    
    open func prepareLayoutCreateHierarchy() {
        fatalError("Override me")
    }

    open func prepareLayoutBySettingAutoLayoutsRules() {
        fatalError("Override me")
    }

    open func prepareLayoutByFinishingPrepareLayout() {
        fatalError("Override me")
    }

    open override func setupColorsAndStyles() {
        fatalError("Override me")
    }

    open func stylesToSetAfterSetupColorsAndStyles() {
        fatalError("Override me")
    }

    open func setupViewUIRx() {
        fatalError("Override me")
    }
    
}

//
// MARK: - BaseViewControllerMVPProtocol
//

extension BaseGenericView: BaseViewProtocol {
    public func displayMessage(title: String, _ message: String, type: AlertType, actions: [CommonNameSpace.AlertAction]) {
        guard let viewController = asView.common.viewController as? BaseViewController else {
            DevTools.Log.error("Fail to present [\(message)]", .generic)
            return
        }
        viewController.displayMessage(title: title, message, type: type, actions: actions)
    }
}

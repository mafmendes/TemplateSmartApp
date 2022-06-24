//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
//
import Common
import DevTools

// swiftlint:disable logs_rule_1

open class StylableLabel: UILabel, StylableProtocol {
    
    public var stylesHandler: StylesHandler = StylesHandler()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }
    
    private func commonInit() {
        // Remove the observer from the table view to prevent it from blanking out the cells
        //NotificationCenter.default.addObserver(self, selector: #selector(contentSizeChanged), name: UIContentSizeCategory.didChangeNotification , object: nil)
    }
    
    @objc func contentSizeChanged() {
        setupColorsAndStyles()
    }
    
    open func setupColorsAndStyles() {
        fatalError("Override me")
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let doWork = { [weak self] in
            self?.setupColorsAndStyles()
            self?.stylesHandler.stylesToSetAfterSetupColorsAndStyles?()
        }
        // Ligth/Dark
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            doWork()
        }
        
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            doWork()
        }
    }
}

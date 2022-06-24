//
//  Created by Ricardo Santos on 22/01/2021.
//

import Foundation
import UIKit
//
import Common
import DevTools
               
open class StylableView: UIView, StylableProtocol {
    
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

    open func commonInit() {
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

open class StylableUITableViewCell: UITableViewCell {

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }

    open func commonInit() {
        setupColorsAndStyles()
    }

    open func setupColorsAndStyles() {
        fatalError("Override me")
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Ligth/Dark
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            setupColorsAndStyles()
        }
    }
}

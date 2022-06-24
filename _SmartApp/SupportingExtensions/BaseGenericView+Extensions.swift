//
//  Created by Santos, Ricardo Patricio dos  on 03/04/2021.
//

import Foundation
import UIKit
//
import Common
import DevTools
import BaseUI
import Resources

extension BaseGenericView {
    
    func installGradientBackground(backgroundGradient: CAGradientLayer?) -> CAGradientLayer? {
        if backgroundGradient != nil {
            backgroundGradient?.removeFromSuperlayer()
        }
        let gradientColor = ColorSemantic.backgroundGradient.uiColor
        return asView.layer.addVerticalGradientBackground(gradientColor.alpha(0.3).cgColor,
                                                          gradientColor.alpha(0).cgColor)
    }
    
    func installDevViewOn(view: UIView) {
        guard !DevTools.onTargetProduction else { return }
        let tap = UITapGestureRecognizer(target: self, action: #selector(displayDevView))
        tap.numberOfTapsRequired = 2
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func displayDevView(gesture: UITapGestureRecognizer) {
        guard !DevTools.onTargetProduction else { return }
        Previews_DeveloperScreen.presentFrom(view: self)
    }
}

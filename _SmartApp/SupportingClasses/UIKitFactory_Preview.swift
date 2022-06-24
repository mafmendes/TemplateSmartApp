//
//  Created by Ricardo Santos on 31/01/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import Common
import BaseUI
import AppConstants
import Designables
import Resources
import DevTools
import AppDomain
import BaseDomain

extension UIStackView {
    
    func dev_loadWithSmartReport_Factory() {
        dev_addSection(title: "Preview : Factory")
        
        dev_addHorizontalView({
            V.ToolBar()
        }, "\(V.ToolBar.self)", VM.ToolBar.Sizes.defaultSize, nil, true)
        
    }
    
}

#if canImport(SwiftUI) && DEBUG
public struct UIFactory_Preview {
    private init() { }
    
    open class PreviewVC: BasePreviewVC {
        public override func loadView() {
            super.loadView()
            stackViewV.dev_loadWithSmartReport_Factory()
            DevTools.paint(self.view, false, 1)
        }
    }
    struct Preview: PreviewProvider {
        static var previews: some View {
            PreviewVC().asAnyView.buildPreviews()
        }
    }
}
#endif

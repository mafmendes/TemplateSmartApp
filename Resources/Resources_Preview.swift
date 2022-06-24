//
//  Created by Santos, Ricardo Patricio dos  on 08/04/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import BaseUI
import Common

public extension UIStackView {
    func dev_loadWithSmartReport_Resources_Full() {
        dev_loadWithSmartReport_Resources_Images()
        dev_loadWithSmartReport_Resources_Fonts()
        dev_loadWithSmartReport_Resources_Colors()
    }
}

#if canImport(SwiftUI) && DEBUG
public struct Resources_Preview {
    private init() { }

    open class PreviewVC: BasePreviewVC {

        public override func loadView() {
            super.loadView()
            stackViewV.dev_loadWithSmartReport_Resources_Full()
        }
    }

    struct Preview: PreviewProvider {
        static var previews: some View {
            PreviewVC().asAnyView.buildPreviews()
        }
    }
}
#endif

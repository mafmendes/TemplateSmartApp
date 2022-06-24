//
//  Created by Ricardo Santos on 29/01/2021.
//

import Foundation
import SwiftUI

public extension UIScreen {
    static var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    static var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
    static var screenSize: CGSize { UIScreen.main.bounds.size }
    
    static var safeAreaTopInset: CGFloat { UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 }
    static var safeAreaBottomInset: CGFloat { UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 }
}

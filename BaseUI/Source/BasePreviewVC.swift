//
//  Created by Santos, Ricardo Patricio dos  on 07/04/2021.
//

import Foundation
import UIKit
import SwiftUI
//
import DevTools

open class BasePreviewVC: UIViewController {
    deinit { }
    
    public init() { super.init(nibName: nil, bundle: nil) }
    public required init?(coder: NSCoder) { super.init(coder: coder) }
    public lazy var scrollView: UIScrollView = { UIScrollView.defaultScrollView() }()
    public lazy var stackViewV: UIStackView = { UIStackView.defaultVerticalStackView() }()
    @Environment(\.colorScheme) var colorScheme

    open override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        
        view.layouts.addAndSetup(scrollView: scrollView, with: stackViewV, usingSafeArea: false)
    }
}

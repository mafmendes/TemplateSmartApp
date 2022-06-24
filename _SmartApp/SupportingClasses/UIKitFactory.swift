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

// swiftlint:disable no_UIKitAdhocConstruction

public extension SmartAppNameSpace {
    
    enum UIFactory {
        
        public static func btnToolbar(image: UIImage,
                                      accessibilityIdentifier: AccessibilityIdentifier = .na) -> UIButton {
            let some = UIButton()
            some.accessibilityIdentifier = accessibilityIdentifier.rawValue
            some.setImageForAllStates(image, tintColor: ColorSemantic.allCool.uiColor)
            return some
        }
        
        //
        // MARK: - Primitive components
        //
        
        /// Default custom BaseLabel
        public static func labelSmart(title: String="",
                                      fontSemantic: FontSemanticSmart? = nil,
                                      accessibilityIdentifier: AccessibilityIdentifier) -> UILabel {
            let some = UILabel()
            some.text = title
            some.numberOfLines = 0
            if let fontSemantic = fontSemantic {
                some.layoutStyle = fontSemantic
            }
            some.tag = AppTags.label.tag
            some.adjustsFontForContentSizeCategory = true
            return some
        }
        
        /// General default UIKit UIButton
        public static func button(title: String,
                                  style: ButtontStyle) -> UIButton {
            let some = UIButton()
            some.tag = AppTags.button.tag
            some.setTitleForAllStates(title)
            some.layoutStyle = style
            return some
        }
        
        /// General default UIKit UIView
        public static func view() -> UIView {
            let some = UIView()
            some.tag = AppTags.view.tag
            return some
        }
        
        /// General default UIKit UIImageView
        public static func containerView() -> UIView {
            let some = view()
            some.tag = AppTags.viewContainer.tag
            return some
        }
        
        /// General default UIKit UIImageView
        public static func imageView(image: UIImage? = nil,
                                     urlString: String? = nil) -> UIImageView {
            let some = UIImageView()
            some.tag = AppTags.imageView.tag
            if image != nil {
                some.image = image
            }
            if urlString != nil, let url = URL(string: urlString!) {
                some.load(url: url)
            }
            return some
        }
        
        /// General default UIKit UITextField
        public static func uiTextField() -> UITextField {
            let some = UITextField()
            some.tag = AppTags.textField.tag
            return some
        }
        
        /// General default UIKit UITableView
        public static func tableView(cellIdentifier: String = "cellIdentifier") -> UITableView {
            let some = UITableView()
            some.tag = AppTags.table.tag
            some.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            return some
        }
        
        /// General default UIKit UIEdgeInsets
        public static var stackViewDefaultLayoutMargins: UIEdgeInsets {
            let topAndBottomSpacing: CGFloat = 0 // Is [ZERO] because [stackViewDefaultSpacing] will do the vertical space (if vertical stackview)
            return UIEdgeInsets(top: topAndBottomSpacing,
                                left: SizeNames.size_4.cgFloat,
                                bottom: topAndBottomSpacing,
                                right: SizeNames.size_4.cgFloat)
        }
        
        /// General default UIKit UIStackView
        public static func stackView(arrangedSubviews: [UIView] = [],
                                     spacing: CGFloat? = SizeNames.size_2.cgFloat, // Space between subviews
                                     axis: NSLayoutConstraint.Axis,
                                     distribution: UIStackView.Distribution = .fill,
                                     alignment: UIStackView.Alignment = .fill,
                                     layoutMargins: UIEdgeInsets? = stackViewDefaultLayoutMargins) -> UIStackView {
            // Distribution: Fill - makes one subview take up most of the space, while the others remain at their natural size.
            //               It decides which view to stretch by examining the content hugging priority for each of the subviews.
            // Distribution: Fill Equally - adjusts each subview so that it takes up equal amount of space in the stack view.
            //               All space will be used up.
            // Distribution: Equal Spacing - adjusts the spacing between subviews without resizing the subviews themselves.
            // Distribution: Equal Centring - attempts to ensure the centers of each subview are equally spaced, irrespective of how far the edge
            //               of each subview is positioned.
            // Distribution: Fill Proportionally - is the most interesting, because it ensures subviews remain the same size relative to each other,
            //               but still stretches them to fit the available space. For example, if one view is 100 across and another is 200, and the
            //               stack view decides to stretch them to take up more space, the first view might stretch to 150 and the other to 300
            //               – both going up by 50%.
            
            let some = UIStackView(arrangedSubviews: arrangedSubviews)
            some.isLayoutMarginsRelativeArrangement = layoutMargins != nil
            if layoutMargins != nil {
                // When isLayoutMarginsRelativeArrangement property is true, the stack view will layout its arranged views relative to its layout margins.
                // Margins of the content views related to each other on the scroll view
                some.autoresizesSubviews = false
                some.layoutMargins = layoutMargins!
            }
            
            // Note
            some.axis         = axis         // determines the stack’s orientation, either vertically or horizontally.
            some.distribution = distribution // determines the layout of the arranged views along the stack’s axis.
            if spacing != nil {
                some.spacing      = spacing!      // determines the minimum spacing between arranged views.
            }
            some.alignment    = alignment    // determines the layout of the arranged views perpendicular to the stack’s axis.
            return some
        }
        
        /// General default UIKit UICollectionView
        public static func collectionView(baseController: UIViewController,
                                          itemSize: CGSize,
                                          direction: UICollectionView.ScrollDirection) -> UICollectionView {
            let margin: CGFloat = 20
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset    = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
            layout.itemSize        = itemSize
            layout.scrollDirection = direction
            let some: UICollectionView = UICollectionView(frame: baseController.view.frame, collectionViewLayout: layout)
            some.dataSource = (baseController as? UICollectionViewDataSource)
            some.delegate   = (baseController as? UICollectionViewDelegate)
            some.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
            some.backgroundColor = UIColor.brown
            baseController.view.addSubview(some)
            return some
        }
    }
}

#if canImport(SwiftUI) && DEBUG
struct PUIFactoryPreview: PreviewProvider {
    static var previews: some View {
        UIFactory_Preview.Preview.previews
    }
}
#endif

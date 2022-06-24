//
//  Created by Ricardo Santos on 23/02/2021.
//

import Foundation
import UIKit

public extension CommonExtension where Target == UICollectionView {
    func deinitialize() { target.deinitialize() }
    func safelySelect(rowAt indexPath: IndexPath) { target.safelySelect(rowAt: indexPath) }
}

public extension UICollectionView {

    func deinitialize() {
        dataSource = nil
        delegate = nil
    }

    func safelySelect(rowAt indexPath: IndexPath) {
        selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        delegate?.collectionView?(self, didSelectItemAt: indexPath)
    }
}

//
//  V.CollectionViewTableView.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 20/06/2022.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    private let posterImageView: UIImageView = {
        let imageView = UIFactory.imageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    override func prepareForReuse() {
        posterImageView.image = nil
    }
    public func configure(with model: String) {
        if model.contains("m.media-amazon") {
            if let index = (model.range(of: "UX")?.lowerBound) {
              let beforeEqualsTo = String(model.prefix(upTo: index))
              let newString = "SY1000_CR0,0,675,1000_AL_.jpg"
              var newModel = beforeEqualsTo
              newModel.append(newString)
              guard let url = URL(string: newModel) else {
                    return
                }
                configureImage(url: url)
            } else if let index = (model.range(of: "UY")?.lowerBound) {
              let beforeEqualsTo = String(model.prefix(upTo: index))
                let newString = "SY1000_CR0,0,675,1000_AL_.jpg"
                var newModel = beforeEqualsTo
                newModel.append(newString)
                guard let url = URL(string: newModel) else {
                    return
                }
                configureImage(url: url)
            }
        } else {
            guard let url = URL(string: model) else {
                return
            }
            configureImage(url: url)
        }
    }
    func configureImage(url: URL) {
        posterImageView.sd_setImage(with: url, placeholderImage: nil)
    }
}

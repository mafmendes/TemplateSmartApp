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
        
        if model.contains("m.media-amazon") || model.contains("imdb-api.com") {
        // So after this 2 caracthers
        if let _ = (model.range(of: "@")?.lowerBound) {
            if let index = (model.range(of: "UX")?.lowerBound) {
          let beforeEqualsTo = String(model.prefix(upTo: index))
          // replace it with this new string, which will give the image a high quality
          let newString = "SY1000_CR0,0,675,1000_AL_.jpg"
            var newModel = beforeEqualsTo
            newModel.append(newString)
            guard let url = URL(string: newModel) else {
                return
            }
                posterImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            else if let index = (model.range(of: "@@")?.lowerBound) {
              // comments above is the same for the following code
              let beforeEqualsTo = String(model.prefix(upTo: index))
              let newString = "@@.jpg"
                var newModel = beforeEqualsTo
                newModel.append(newString)
                guard let url = URL(string: newModel) else {
                    return
                }
                print("oiri2")
                print(url)
                posterImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            else if let index = (model.range(of: "@._V1")?.lowerBound) {
              // comments above is the same for the following code
              let beforeEqualsTo = String(model.prefix(upTo: index))
              let newString = "@@.jpg"
                var newModel = beforeEqualsTo
                newModel.append(newString)
                guard let url = URL(string: newModel) else {
                    return
                }
                print("oiri3")
                print(url)
                posterImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            else if let index = (model.range(of: "._V1")?.lowerBound) {
              // comments above is the same for the following code
              let beforeEqualsTo = String(model.prefix(upTo: index))
              let newString = ".@@.jpg"
                var newModel = beforeEqualsTo
                newModel.append(newString)
                guard let url = URL(string: newModel) else {
                    return
                }

                posterImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        } else if let index = (model.range(of: "._V1")?.lowerBound) {
          // comments above is the same for the following code
          let beforeEqualsTo = String(model.prefix(upTo: index))
          let newString = ".@@.jpg"
            var newModel = beforeEqualsTo
            newModel.append(newString)
            guard let url = URL(string: newModel) else {
                return
            }

            posterImageView.sd_setImage(with: url, placeholderImage: nil)
        }
    } else {
//        if let index = (imageView.range(of: "V1_Ratio0")?.lowerBound) {
//          let beforeEqualsTo = String(imageView.prefix(upTo: index))
//          // replace it with this new string, which will give the image a high quality
//          let newString = "SY1000_CR0,0,675,1000_AL_.jpg"
//            var newModel = beforeEqualsTo
//            newModel.append(newString)
//            guard let url = URL(string: newModel) else {
//                return
//            }
//            print("ola")
//            print(url)
//                posterImageView.sd_setImage(with: url, placeholderImage: nil)
//        }
        //else {
            guard let url = URL(string: model) else {
                return
            }
            posterImageView.sd_setImage(with: url, placeholderImage: nil)
        //}
        
    }
    }
    func configureImage(url: URL) {
        posterImageView.load(url: url, downsample: false)
        //posterImageView.sd_setImage(with: url, placeholderImage: nil)
    }
}

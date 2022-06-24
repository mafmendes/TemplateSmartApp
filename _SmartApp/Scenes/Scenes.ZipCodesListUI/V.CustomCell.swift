//
//  V.CustomCell.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 18/04/2022.
//

import Foundation
import UIKit
import Combine
import SwiftUI
//
import Common
import BaseUI
import BaseDomain
import DevTools
import Resources
import Designables
import AppConstants
import AppDomain

extension V {
    
    class CustomCell: StylableUITableViewCell {
        
        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }
        
        var cellItem: VM.ZipCodesListUIHolder.TableItem? {
            
            didSet {
                cellTitle.text = cellItem?.title
                cellSubtitle.text = cellItem?.value
                fillImage2()
                //cellSubtitle.largeContentImage = cellImage.image
            
            }
        }
        
        private lazy var cellTitle: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .na)

        }()
        
        private lazy var cellSubtitle: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .na)

        }()
        
        private var cellImage: UIImageView = {
            UIFactory.imageView()
        }()
        
        private var task: URLSessionDownloadTask?
        
        open override func prepareForReuse() {
            super.prepareForReuse()
            cellImage.image = ImageName.new.uiImage
            task?.cancel()
            
        }
        
        open override func setupColorsAndStyles() {
            cellTitle.applyStyle(.bodyBold, .labelPrimary)
            cellSubtitle.textColor = ColorSemantic.labelPrimary.uiColor.alpha(0.3)
            cellSubtitle.font = FontSemanticSmart.caption1.uiFont
            
            fillImage2()
           
            cellImage.heightAnchor.constraint(equalToConstant: VM.CustomCell.Sizes.imageDogHeight).isActive = true
            cellImage.widthAnchor.constraint(equalToConstant: VM.CustomCell.Sizes.imageDogWidth).isActive = true
            
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            addSubview(cellTitle)
            addSubview(cellSubtitle)
            addSubview(cellImage)
            
            let stackView = UIStackView(arrangedSubviews: [cellTitle, cellSubtitle])
            
            stackView.axis = .vertical
            stackView.spacing = 5
            addSubview(stackView)
            stackView.alignment = .trailing
            stackView.layouts.trailingToSuperview(offset: SizeNames.defaultMargin)
            
            cellImage.layouts.leadingToSuperview()
            cellImage.layouts.centerYToSuperview()
            
         }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func fillImage() {
            if traitCollection.userInterfaceStyle == .light {
                cellImage.imageFromURL(urlString: VM.CustomCell.URLS.urlImagLightMode) { _ in
                    return
                }
            } else {
                cellImage.imageFromURL(urlString: VM.CustomCell.URLS.urlImageDarkMode) { _ in
                    return
                }
               
            }
        }
        
        func fillImage2() {
            if traitCollection.userInterfaceStyle == .light {
                cellImage.image = cellItem?.imageLight.toImage()
            } else {
                cellImage.image = cellItem?.imageDark.toImage()
            }
        }
    }
    
}

extension UIImageView {

    public func imageFromURL(urlString: String, _ handler: @escaping ((String?) -> Void)) {
         
            URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, _, error) -> Void in

                if error != nil {
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.image = image
                    handler(image?.toPngString())
                    
                })

            }).resume()
        
    }
    
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}

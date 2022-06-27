//
//  V.MovieScreenDetailView.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 22/06/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
import Combine
//
import Common
import DevTools
import BaseDomain
import AppDomain
import BaseUI
import Designables
import Resources
import AppConstants
#warning("BACK BUTTON NO DETAIL SCREEN")
#warning("Tutorial: V._xxx_View files ->")

//
// V.MovieScreenDetailView files are used for:
//  - Build the UI
//  - Expose to the UIViewController (via Combine and on extension on file end) the user interactor events
//
// Naming convention: Given a Scene named MovieScreenDetail -> MovieScreenDetailView
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PMovieScreenDetailVPreviews: PreviewProvider {
    static var previews: some View {
        // Common_ViewRepresentable(V.MovieScreenDetailView())
        Common_ViewRepresentable { V.MovieScreenDetailView() }.buildPreviews()
    }
}
#endif

extension V {

    public class MovieScreenDetailView: BaseGenericView,
                                               GenericViewProtocol,
                                               MVVMGenericViewProtocol {

        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }

        public typealias ViewData = VM.MovieScreenDetail.ViewInput.ViewData
        public typealias ViewOutput = VM.MovieScreenDetail.ViewOutput.Action
        public var output = GenericObservableObjectForHashable<ViewOutput>()
        public var input = MVVMViewInputObservable<ViewData>()
        
        //
        // MARK: - UI Elements (Private and lazy by default)
        //
        
        private var backgroundGradient: CAGradientLayer?

        #warning("Tutorial: UI elements are ussually [private] AND [lazy]")
        private lazy var scrollView: UIScrollView = {
            UIScrollView()
        }()
        private lazy var scrollStackViewContainer: UIStackView = {
            UIStackView()
        }()
        private lazy var titleLabel: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        private lazy var descriptionLabel: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        private lazy var ratingLabel: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        private lazy var actorsLabel: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        private lazy var downloadButton: UIButton = {
            UIFactory.button(title: "Download", style: .notApplied)
        }()
        private lazy var posterImageView: UIImageView = {
            UIFactory.imageView()
        }()
        
        //
        // MARK: - View Life Cicle : Mandatory
        //
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        public override func prepareLayoutCreateHierarchy() {
            addSubview(scrollView)
            scrollView.addSubview(scrollStackViewContainer)
            scrollStackViewContainer.addArrangedSubview(posterImageView)
            scrollStackViewContainer.addArrangedSubview(titleLabel)
            scrollStackViewContainer.addArrangedSubview(ratingLabel)
            scrollStackViewContainer.addArrangedSubview(actorsLabel)
            scrollStackViewContainer.addArrangedSubview(descriptionLabel)
            scrollStackViewContainer.addArrangedSubview(downloadButton)
           
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            scrollStackViewContainer.axis = .vertical
            posterImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
            
            let margins = layoutMarginsGuide
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            let scrollViewConstraints = [
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ]
            scrollStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
            let scrollStackContainerConstraints = [
                scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
                scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ]
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            ratingLabel.translatesAutoresizingMaskIntoConstraints = false
            actorsLabel.translatesAutoresizingMaskIntoConstraints = false
            posterImageView.translatesAutoresizingMaskIntoConstraints = false
            posterImageView.heightAnchor.constraint(equalToConstant: 500).isActive = true
            downloadButton.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            posterImageView.translatesAutoresizingMaskIntoConstraints = false
            scrollStackViewContainer.setCustomSpacing(50, after: posterImageView)
            scrollStackViewContainer.setCustomSpacing(20, after: titleLabel)
            scrollStackViewContainer.setCustomSpacing(20, after: ratingLabel)
            scrollStackViewContainer.setCustomSpacing(20, after: actorsLabel)
            scrollStackViewContainer.setCustomSpacing(20, after: descriptionLabel)
            NSLayoutConstraint.activate(scrollViewConstraints)
            NSLayoutConstraint.activate(scrollStackContainerConstraints)

        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        public override func prepareLayoutByFinishingPrepareLayout() {
            titleLabel.numberOfLines = 0
            ratingLabel.numberOfLines = 0
            actorsLabel.numberOfLines = 0
            descriptionLabel.numberOfLines = 0
            downloadButton.setTitle("Download", for: .normal)
            downloadButton.layer.cornerRadius = 8
            downloadButton.layer.masksToBounds = true
            installDevViewOn(view: asView)
        }
        
        public override func setupColorsAndStyles() {
            backgroundGradient = installGradientBackground(backgroundGradient: backgroundGradient)
            backgroundColor = ColorSemantic.backgroundPrimary.uiColor
            titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
            ratingLabel.font = .systemFont(ofSize: 18, weight: .regular)
            actorsLabel.font = .systemFont(ofSize: 18, weight: .regular)
            descriptionLabel.font = .systemFont(ofSize: 18, weight: .regular)
            downloadButton.setTitleColor(.white, for: .normal)
            downloadButton.backgroundColor = .red
            
        }
        
        // This function is called automatically by super BaseGenericView
        // All reactive behaviours should be inside this function
        public override func setupViewUIRx() {

            // Handle View inputs and to view screen
            input.value.sink { [weak self] (state) in
                guard let self = self else { return }
                self.handle(stateInput: state)
            }.store(in: cancelBag)
            
            // Fwd to ViewController
            downloadButton.combine.touchUpInsidePublisher.sink { [weak self] (_) in
                guard let self = self else { return }
                self.fwdStateToViewController(.btnDownloadClicked(movie: self.titleLabel.text!))
            }.store(in: cancelBag)
            
        }
    }
}

//
// MARK: - MovieScreenDetailViewProtocol
//

extension V.MovieScreenDetailView: MovieScreenDetailViewProtocol {
    
    func viewWillAppear() {
        // Will be called by the ViewContoller (remember this class is View)
    }
    
    func viewWillFirstAppear() {
        // Will be called by the ViewContoller (remember this class is View)
    }
    
    func viewDidAppear() {
        // Will be called by the ViewContoller (remember this class is View)
    }
}
    
//
// MARK: - setupWith(viewModel: ViewData)
// This section is mandatory for all (Scene) Views, and is were we andle data sent by the ViewController/ViewModel
//

extension V.MovieScreenDetailView {

    /// Use to put the screen/view on his initial state, (not necessaring reload all the data)
    func softReLoad() {
        
    }
    
    #warning("Tutorial: The place were our View receives the Actions from the ViewModel")
    func handle(stateInput: MVVMViewInput<ViewData>) {
        DevTools.Log.trace(stateInput, .view)
        guard let viewController = asView.common.viewController else { return }
        guard let baseViewController = viewController as? BaseViewController else { return }
        Common_Utils.executeInMainTread { [weak baseViewController] in
            switch stateInput {
            case .loading(model: let model): baseViewController?.displayLoading(viewModel: model)
            case .loaded(let model): self.setupWith(viewModel: model)
            case .error(let error, let devMessage):
                var message = "\(Message.pleaseTryAgainLater.localised)\n\n\(error.localizedDescription)"
                if let error = error as? AppErrors, let messageForUI = error.localisedForUser {
                    message = messageForUI
                }
                baseViewController?.displayError(viewModel: .init(title: "",
                                                                  message: message,
                                                                  devMessage: "\(devMessage)"))
            case .softReLoad: self.softReLoad()
            }
        }
    }

    #warning("Tutorial: Helper for [func handle(stateInput: MVVMViewInput<ViewData>)] were we hangle the [loaded] case")
    /// Where to handle the ViewData sent by the ViewModel/ViewController and display it on the view
    func setupWith(viewModel: ViewData) {
        switch viewModel {
        
        case .displayScreenBlockingMessage(value: let value, type: let type):
            break
        case .nevesView(user: let user,
                        password: let password,
                        message: let message,
                        isVisible: let isVisible):
            break
        case .displayData(fullTitle: let fullTitle, title: let title, imageView: let imageView,
            description: let description, imDbRating: let imDbRating,
            metacriticRating: let metacriticRating, actors: let actors):
            configureInformation(fullTitle: fullTitle, title: title, imageView: imageView, description: description, imDbRating: imDbRating, metacriticRating: metacriticRating, actors: actors)
        case .displayAlert(title: let title, type: let type):
            displayMessage(title: "", "Do you want to download \(title) ?", type: type, actions: [CommonNameSpace.AlertAction(title: "Yes", style: .default, action: {
            }), CommonNameSpace.AlertAction(title: "No", style: .default, action: {
            })])
            
        }
    }
}
extension V.MovieScreenDetailView {
    func configureInformation( fullTitle: String, title: String, imageView: String, description: String, imDbRating: String, metacriticRating: String, actors: String) {
        print("OLA")
        print(fullTitle)
        print(title)
        print(imageView)
        if imageView.contains("m.media-amazon") || imageView.contains("imdb-api.com") {
        // So after this 2 caracthers
        if let _ = (imageView.range(of: "@")?.lowerBound) {
            if let index = (imageView.range(of: "UX")?.lowerBound) {
          let beforeEqualsTo = String(imageView.prefix(upTo: index))
          // replace it with this new string, which will give the image a high quality
          let newString = "SY1000_CR0,0,675,1000_AL_.jpg"
            var newModel = beforeEqualsTo
            newModel.append(newString)
            guard let url = URL(string: newModel) else {
                return
            }
                posterImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            else if let index = (imageView.range(of: "@@")?.lowerBound) {
              // comments above is the same for the following code
              let beforeEqualsTo = String(imageView.prefix(upTo: index))
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
            else if let index = (imageView.range(of: "@._V1")?.lowerBound) {
              // comments above is the same for the following code
              let beforeEqualsTo = String(imageView.prefix(upTo: index))
              let newString = "@.jpg"
                var newModel = beforeEqualsTo
                newModel.append(newString)
                guard let url = URL(string: newModel) else {
                    return
                }
                print("oiri3")
                print(url)
                posterImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            else if let index = (imageView.range(of: "._V1")?.lowerBound) {
              // comments above is the same for the following code
              let beforeEqualsTo = String(imageView.prefix(upTo: index))
              let newString = ".@@.jpg"
                var newModel = beforeEqualsTo
                newModel.append(newString)
                guard let url = URL(string: newModel) else {
                    return
                }
                print("oiri")
                print(url)
                posterImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        } else if let index = (imageView.range(of: "._V1")?.lowerBound) {
          // comments above is the same for the following code
          let beforeEqualsTo = String(imageView.prefix(upTo: index))
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
            guard let url = URL(string: imageView) else {
                return
            }
            posterImageView.sd_setImage(with: url, placeholderImage: nil)
        //}
        
    }
    titleLabel.text = fullTitle
    if imDbRating.isEmpty && metacriticRating.isEmpty {
    } else {
        if imDbRating.isEmpty {
            ratingLabel.attributedText = attributedText(
                withString: String(format: "Metacritic Rating: " + metacriticRating),
                boldString: "Metacritic Rating:", font: ratingLabel.font)
        } else if metacriticRating.isEmpty {
            ratingLabel.attributedText = attributedText(
                withString: String(format: "imDB Rating: " + imDbRating),
                boldString: "imDB Rating:", font: ratingLabel.font)
        }
    }
    if !actors.isEmpty {
        actorsLabel.attributedText = attributedText(
            withString: String(format: "Crew: " + actors),
            boldString: "Crew:", font: actorsLabel.font)
    }
    if !description.isEmpty {
        descriptionLabel.attributedText = attributedText(
            withString: String(format: "Description: " + description),
            boldString: "Description:", font: descriptionLabel.font)
    }
        
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}

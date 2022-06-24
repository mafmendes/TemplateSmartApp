//
//  V.MoviesView.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 09/06/2022.
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

#warning("Tutorial: V._xxx_View files ->")

//
// V.MoviesView files are used for:
//  - Build the UI
//  - Expose to the UIViewController (via Combine and on extension on file end) the user interactor events
//
// Naming convention: Given a Scene named Movies -> MoviesView
//

#if canImport(SwiftUI) && DEBUG
// Cant be private/fileprivate
// struct name cant start with _
struct PMoviesVPreviews: PreviewProvider {
    static var previews: some View {
        // Common_ViewRepresentable(V.MoviesView())
        Common_ViewRepresentable { V.MoviesView() }.buildPreviews()
    }
}
#endif

extension V {

    public class MoviesView: BaseGenericView,
                                               GenericViewProtocol,
                                               MVVMGenericViewProtocol, UITableViewDelegate, UITableViewDataSource {

        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }

        public typealias ViewData = VM.Movies.ViewInput.ViewData
        public typealias ViewOutput = VM.Movies.ViewOutput.Action
        public var output = GenericObservableObjectForHashable<ViewOutput>()
        public var input = MVVMViewInputObservable<ViewData>()
        
        //
        // MARK: - UI Elements (Private and lazy by default)
        //
        
        private var backgroundGradient: CAGradientLayer?

        #warning("Tutorial: UI elements are ussually [private] AND [lazy]")
        private lazy var searchField: UISearchTextField = {
            UISearchTextField()
        }()
        
        private lazy var tableView: UITableView = {
            UITableView(frame: .zero, style: .grouped)

        }()
        
        private lazy var searchResultsCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: SearchResultsSizes.collectionViewWidth,
                                     height: SearchResultsSizes.collectionViewHeight)
            layout.minimumInteritemSpacing = 0
            return UICollectionView(frame: .zero, collectionViewLayout: layout)
        }()
        private lazy var noResultsLabel: UILabel = {
            UIFactory.labelSmart(accessibilityIdentifier: .someLabel)
        }()
        private var movies: [Model.Movie] = [Model.Movie]()
        private var activityIndicator = UIActivityIndicatorView(style: .large)
        private var didTapDeleteKey = false
        
        //
        // MARK: - View Life Cicle : Mandatory
        //
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 1/3 : JUST to add stuff to the view....
        public override func prepareLayoutCreateHierarchy() {
            addSubview(searchField)
            addSubview(tableView)
            addSubview(noResultsLabel)
            addSubview(activityIndicator)
        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 2/3 : JUST to setup layout rules zone....
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
            searchField.layouts.topToSuperview(offset: 0, usingSafeArea: true)
            searchField.layouts.leadingToSuperview(offset: SizeNames.defaultMargin)
            searchField.layouts.trailingToSuperview(offset: SizeNames.defaultMargin)
            searchField.layouts.height(SizeNames.defaultMargin * 2)
            
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: SizeNames.defaultMargin).isActive = true
            tableView.leftAnchor.constraint(equalTo: superview!.leftAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: superview!.rightAnchor).isActive = true
            
            noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
            let noResultsLabelConstraints = [
                        noResultsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120),
                        noResultsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                        noResultsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
                    ]
            NSLayoutConstraint.activate(noResultsLabelConstraints)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        }
        
        // This function is called automatically by super BaseGenericView
        // There are 3 functions specialised according to what we are doing. Please use them accordingly
        // Function 3/3 : Stuff that is not included in [prepareLayoutCreateHierarchy] and [prepareLayoutBySettingAutoLayoutsRules]
        public override func prepareLayoutByFinishingPrepareLayout() {
            tableView.register(V.TableViewCell.self, forCellReuseIdentifier: VM.Movies.MovieListConstants.tableIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            searchResultsCollectionView.register(CollectionViewCell.self,
                                                 forCellWithReuseIdentifier: VM.Movies.MovieListConstants.cellIdentifier)
            searchResultsCollectionView.delegate = self
            searchResultsCollectionView.dataSource = self
            searchResultsCollectionView.translatesAutoresizingMaskIntoConstraints = false
            installDevViewOn(view: asView)
        }
        
        public override func setupColorsAndStyles() {
            backgroundGradient = installGradientBackground(backgroundGradient: backgroundGradient)
            backgroundColor = ColorSemantic.backgroundPrimary.uiColor
            noResultsLabel.font = .systemFont(ofSize: 22, weight: .bold)
            noResultsLabel.numberOfLines = 0
            activityIndicator.color = .systemGray
            searchField.text = ConfigureDefaults.defaults
            
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
            searchField.editingChangedPublisher.sinkToReceiveValue { [weak self] (some) in
                guard let self = self else { return }
                if let toSearch = some.sucessUnWrappedValue as? String {
                    if !toSearch.isEmpty { ConfigureDefaults.defaults = toSearch}
                    self.activityIndicator.startAnimating()
                    self.fwdStateToViewController(.search(value: toSearch))
                }
            }.store(in: cancelBag)
            
        }
    }
}

//
// MARK: - MoviesViewProtocol
//

extension V.MoviesView: MoviesViewProtocol {
    
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

extension V.MoviesView {

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
        case .displayResults(movies: let moviestoDisplay):
            //resultsController.delegate = self
            addSubview(searchResultsCollectionView)
            searchResultsCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: SizeNames.defaultMargin).isActive = true
            searchResultsCollectionView.leftAnchor.constraint(equalTo: superview!.leftAnchor).isActive = true
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            searchResultsCollectionView.rightAnchor.constraint(equalTo: superview!.rightAnchor).isActive = true
            self.tableView.removeFromSuperview()
            self.movies = moviestoDisplay
            
            self.searchResultsCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
            if self.movies.count == 0 {
                self.noResultsLabel.text = "Your search has no results. Try again!"
            } else {
                self.noResultsLabel.text = ""
            }
        case .noResults:
            self.activityIndicator.stopAnimating()
            self.searchResultsCollectionView.removeFromSuperview()
            addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: SizeNames.defaultMargin).isActive = true
            tableView.leftAnchor.constraint(equalTo: superview!.leftAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: superview!.bottomAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: superview!.rightAnchor).isActive = true
        }
    }
}

extension V.MoviesView {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return VM.Movies.MovieListConstants.sectionTitles.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VM.Movies.MovieListConstants.tableIdentifier, for: indexPath) as? V.TableViewCell else {
            return UITableViewCell()
        }
        self.fwdStateToViewController(.configureRows(indexPath: indexPath, delay: false, displayLoading: false, cell: cell))
        cell.delegate = self
        //viewModel.configureRows(indexPath: indexPath, cell: cell)
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        #warning("Value is too hardcoded, maybe change it")
        return 200
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        VM.Movies.MovieListConstants.sectionTitles[section]
    }
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20,
                                         y: header.bounds.origin.y, width: 100,
                                         height: header.bounds.height)
    }
                        
}

extension V.MoviesView: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: V.TableViewCell, viewModel: Model.MovieDetail) {
        self.fwdStateToViewController(.cellPressed(cell: cell, viewModel: viewModel))
    }
}

extension V.MoviesView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    public func collectionView(_
                        collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VM.Movies.MovieListConstants.cellIdentifier,
            for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.row]
        cell.configure(with: movie.image ?? "")
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        self.fwdStateToViewController(.itemPressed(indexPath: indexPath, movies: movies))
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let totalHeight: CGFloat = (self.frame.width / 3)
        let totalWidth: CGFloat = (self.frame.width / 3)

        return CGSize(width: ceil(totalWidth), height: ceil(totalHeight))
    }
}

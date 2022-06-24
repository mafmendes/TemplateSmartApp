//
//  D.MoviesDomain.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 09/06/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
//
import BaseDomain
import AppDomain
import BaseUI
import AppConstants

#warning("Tutorial: D._xxx_Domain files ->")

//
// D.MoviesDomain files are used for:
//  - Declare Models (value types)
//  - Declare the View Protocol       -> MoviesViewProtocol
//  - Declate ViewController Protocol -> MoviesViewControllerProtocol
//  - Declate ViewModel Protocol      -> MoviesViewModelProtocol
//  - Declate Coordinator Protocol    -> MoviesCoordinatorProtocol
//

//
// MARK: - Protocols
//

/// The Scene Coordinator Protocol
protocol MoviesCoordinatorProtocol {
    func perform(_ action: C.MoviesCoordinator.Action)
    var viewController: UIViewController? { get }
    var childViewControllers: [UIViewController] { get }
    var viewControllerProtocol: MoviesViewControllerProtocol? { get }
}

/// The View ViewController Protocol
protocol MoviesViewProtocol {
    func viewWillAppear()
    func viewWillFirstAppear()
    func viewDidAppear()
}

/// The Scene ViewController Protocol
protocol MoviesViewControllerProtocol {

}

/// The Scene ViewModel Protocol
protocol MoviesViewModelProtocol {

}

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: V.TableViewCell, viewModel: Model.MovieDetail)
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: Model.MovieDetail)
}

enum SearchResultsSizes {
    static var collectionViewWidth: CGFloat { 100 }
    static var collectionViewHeight: CGFloat { 200 }
}

//
// MARK: - Models
//

public extension VM {

    //
    // Naming convention: Given a Scene named D.MoviesDomain -> D.MoviesDomain
    //

    enum Movies {

        //
        // Sizes
        //
        
        enum Sizes {
            static var btnDismissSize: CGSize { .init(width: SizeNames.size_15.cgFloat, height: SizeNames.size_10.cgFloat) }
        }
        
        //
        // Constants
        //
        
        enum Constants {
            static var tableIdentifier = "cellMovies"
        }
        
        enum MovieListConstants {
            static var sectionTitles: [String] {  ["Most Popular", "Top 250 Movies", "In theaters", "Comming Soon"]}
            static var tableIdentifier = "CollectionViewTableViewCell"
            static var cellIdentifier = "CollectionViewCell"
        }
        enum Sections: Int {
            case mostPopular = 0
            case top250Movies = 1
            case inTheaters = 2
            case commingSoon = 3
        }
        
        enum StorageKeys: String {

            case searchBarStorageKey = "RecentSearch"

        }
        
        //
        // ViewModelInput: ViewController -> ViewModel
        // (The things that our ViewModel can do)
        // struct naming convention: ViewModelInput, allways, Hashable allways

        #warning("Tutorial: The things that our ViewModel can do")
        enum ViewModelInput {

            struct InitialSetup: Hashable {
                let name: String
            }

            // Rule : naming convention: Action, allways
            enum Action: Hashable {
                
                // Action naming rules:
                // 1 : [viewLoaded] and [softReLoad] Actions are mandatory.
                // 2 : Actions that are just "gets" of information, should start with "get" or end with "Refresh"
                // 3 : Actions who lead to screen change, shoud start with "route"
                
                // Mandatory Actions
                case viewLoaded // Get screen initial state (allways updating most recent data)
                case softReLoad // Use to put the screen/view on his initial state (without reloading)

                case routeToSampleScreen
                case routeToDismiss
                
                case handle(user: String, password: String)
                case configureRows(indexPath: IndexPath, delay: Bool, displayLoading: Bool, cell: V.TableViewCell)
                case cellPressed(cell: V.TableViewCell, viewModel: Model.MovieDetail)
                case getSearchResults(value: String)
                case handleItemPressed(indexPath: IndexPath, movies: [Model.Movie])
            }
        }

        //
        // ViewOutput: View -> ViewController
        // (The things that our view can tell to the ViewController that happened (from UI point of view)
        // struct naming convention: ViewOutput, allways, Hashable allways
        
        #warning("Tutorial: The things that our view can tell to the ViewController that happened (from UI point of view")
        public enum ViewOutput {
            public enum Action: Hashable {
                case btnDismissTapped
                case userTyped(user: String, password: String)
                case configureRows(indexPath: IndexPath, delay: Bool, displayLoading: Bool, cell: V.TableViewCell)
                case cellPressed(cell: V.TableViewCell, viewModel: Model.MovieDetail)
                case search(value: String)
                case itemPressed(indexPath: IndexPath, movies: [Model.Movie])
            }
        }

        //
        // ViewInput: ViewModel -> View
        // (The things that our View can do/receive)
        // struct naming convention: ViewInput, allways, Hashable allways

        #warning("Tutorial: The things that our View can do/receive")
        public enum ViewInput {
  
            /// __ViewInput.ViewData__: Information sent from ViewModel to View. Should allways be _Hashable_ and _Enum_
            public enum ViewData: Hashable {
                case displayResults(movies: [Model.Movie])
                case noResults
//                case displayScreenBlockingMessage(value: String, type: AlertType)
//                case nevesView(user: String, password: String, message: String, isVisible: Bool)
            }
        }
    }
}

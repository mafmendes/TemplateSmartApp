//
//  V.TableViewCell.swift
//  SmartApp
//
//  Created by Mendes, Mafalda Joana on 22/06/2022.
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
    
    public class TableViewCell: StylableUITableViewCell {
        
        deinit {
            NotificationCenter.default.removeObserver(self)
            DevTools.Log.trace("\(Self.self) deinit", .generic)
        }
        
        weak var delegate: CollectionViewTableViewCellDelegate?
        private var moviesInformation: [Model.Movie] = [Model.Movie]()
        private let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 140, height: 200)
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: VM.Movies.MovieListConstants.cellIdentifier)
            return collectionView
        }()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = .systemPink
            contentView.addSubview(collectionView)
            collectionView.delegate = self
            collectionView.dataSource = self
        }

        required init?(coder: NSCoder) {
            fatalError()
        }
        public override func layoutSubviews() {
            super.layoutSubviews()
            collectionView.frame = contentView.bounds
        }
        public func configure(with moviesInfo: [Model.Movie]) {
            self.moviesInformation = moviesInfo
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
        open override func setupColorsAndStyles() {
            
        }
    }
}

extension V.TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VM.Movies.MovieListConstants.cellIdentifier,
                                                                for: indexPath) as? CollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let image = moviesInformation[indexPath.row].image else {
                return UICollectionViewCell()
            }
            cell.configure(with: image)
            return cell
        }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            moviesInformation.count
        }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let moviesInfo = moviesInformation[indexPath.row]
        guard let movieName = moviesInfo.fullTitle ?? moviesInfo.fullTitle,
                let movieImage = moviesInfo.image ?? moviesInfo.image,
                let movieImDBRating = moviesInfo.imDbRating ?? Optional(""),
                let movieMetaCriticRating = moviesInfo.metacriticRating ?? Optional(""),
                let movieDescription = moviesInfo.plot ?? Optional(""),
                let movieActors = moviesInfo.crew ?? moviesInfo.stars
        else {
            return
        }
        let viewModel = Model.MovieDetail(fullTitle: movieName, title: movieName,
                                    imageView: movieImage,
                                    description: movieDescription,
                                    imDbRating: movieImDBRating,
                                    metacriticRating: movieMetaCriticRating,
                                    actors: movieActors)
        delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: viewModel)
    }
    }

//
//  Model+Movies.swift
//  AppDomain
//
//  Created by Mendes, Mafalda Joana on 17/06/2022.
//
import Foundation
//
import BaseDomain

public extension Model {
    
    /// `ModelDto.PortugueseZipCodeResponse` and `Model.PortugueseZipCode` are related
    /// `ModelDto` is to be used to map _foreingn enteties_ and `Model` is used by the app (views)
    /// `ModelDto` usually ends with _Response_ keyoword
    struct MovieResponse: ModelProtocol {
        public let items: [Movie]?
        public let results: [Movie]?
    }
    struct Movie: ModelProtocol {
        public let id: String?
        public let crew: String?
        public let title: String?
        public let fullTitle: String?
        public let image: String?
        public let imDbRating: String?
        public let imDbRatingCount: String?
        public let rank: String?
        public let rankUpDown: String?
        public let year: String?
        public let releaseState: String?
        public let runtimeMins: String?
        public let runtimeStr: String?
        public let plot: String?
        public let description: String?
        public let contentRating: String?
        public let metacriticRating: String?
        public let genres: String?
        public let genresList: [Genres]?
        public let directors: String?
        public let directorsList: [Directors]?
        public let stars: String?
        public let starsList: [Stars]?
    }

    struct Genres: ModelProtocol {
        public let key: String?
        public let value: String?
    }

    struct Directors: ModelProtocol {
        public let id: String?
        public let name: String?
    }

    struct Stars: ModelProtocol {
        public let id: String?
        public let name: String?
    }

}

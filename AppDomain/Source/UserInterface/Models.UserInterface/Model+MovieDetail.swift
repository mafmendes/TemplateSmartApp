//
//  Model+MovieDetail.swift
//  AppDomain
//
//  Created by Mendes, Mafalda Joana on 21/06/2022.
//

import Foundation
import BaseDomain

public extension Model {
    struct MovieDetail: ModelProtocol {
        public let fullTitle: String
        public let title: String
        public let imageView: String
        public let description: String
        public let imDbRating: String
        public let metacriticRating: String
        public let actors: String
        
        public init(fullTitle: String,
                    title: String,
                    imageView: String,
                    description: String,
                    imDbRating: String, metacriticRating: String, actors: String) {
            self.fullTitle = fullTitle
            self.title = title
            self.imageView = imageView
            self.description = description
            self.imDbRating = imDbRating
            self.metacriticRating = metacriticRating
            self.actors = actors
        }
    }
}

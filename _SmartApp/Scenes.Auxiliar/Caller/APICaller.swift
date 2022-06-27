//
//  APiCaller.swift
//  AppCore
//
//  Created by Mendes, Mafalda Joana on 17/06/2022.
//
import Foundation
import Alamofire
import SwiftUI
import Combine
//
import Common
import Resources
import DevTools
import BaseDomain
import AppDomain
import AppCore
import BaseUI
import AppConstants

struct Constants {
    static let apiKey = "k_h19su5vw"// "k_o4g32is7"//"k_k5beia58" //"k_rxtomrn7" // k_h19su5vw
    static let baseURL = "https://imdb-api.com/API"
}

enum APIError: Error {
    case failedToGetData
    case URLfailed
    case failedRequest
    case faieldEnconding
    case emptyString
}

class APICaller {
    static let shared = APICaller()
    func getMostPopularMovies(completion: @escaping (Result<[Model.Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/MostPopularMovies/\(Constants.apiKey)") else {
            completion(.failure(APIError.URLfailed))
            return
        }
        AF.request(url).validate().responseDecodable(of: Model.MovieResponse.self) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(APIError.failedRequest))
                return
            }
            do {
                let results = try JSONDecoder().decode(Model.MovieResponse.self, from: data)
                completion(.success(results.items!))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
    }
    func getTop250Movies(completion: @escaping (Result<[Model.Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/Top250Movies/\(Constants.apiKey)") else {
            completion(.failure(APIError.URLfailed))
            return
        }
        AF.request(url).validate().responseDecodable(of: Model.MovieResponse.self) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(APIError.failedRequest))
                return
            }
            do {
                let results = try JSONDecoder().decode(Model.MovieResponse.self, from: data)
                completion(.success(results.items!))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
    }
    func getInTheaters(completion: @escaping (Result<[Model.Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/InTheaters/\(Constants.apiKey)") else {
            completion(.failure(APIError.URLfailed))
            return
        }
        AF.request(url).validate().responseDecodable(of: Model.MovieResponse.self) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(APIError.failedRequest))
                return
            }
            do {
                let results = try JSONDecoder().decode(Model.MovieResponse.self, from: data)
                completion(.success(results.items!))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
    }
    func getCommingSoonMovies(completion: @escaping (Result<[Model.Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/ComingSoon/\(Constants.apiKey)") else {
            completion(.failure(APIError.URLfailed))
            return
        }
        AF.request(url).validate().responseDecodable(of: Model.MovieResponse.self) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(APIError.failedRequest))
                return
            }
            do {
                let results = try JSONDecoder().decode(Model.MovieResponse.self, from: data)
                completion(.success(results.items!))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
    }
    func searchMovie(with movie: String, completion: @escaping (Result<[Model.Movie], Error>) -> Void) {
        guard let movie = movie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(APIError.faieldEnconding))
            return
        }
        guard !movie.isEmpty else {
            completion(.failure(APIError.emptyString))
            return
        }
        guard let url = URL(string: "\(Constants.baseURL)/SearchMovie/\(Constants.apiKey)/\(movie)") else {
            completion(.failure(APIError.URLfailed))
            return
        }
        AF.request(url).validate().responseDecodable(of: Model.MovieResponse.self) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(APIError.failedRequest))
                return
            }
            do {
                let results = try JSONDecoder().decode(Model.MovieResponse.self, from: data)
                completion(.success(results.results!))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        }
    }
}

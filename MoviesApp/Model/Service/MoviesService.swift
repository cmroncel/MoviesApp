//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation
import Moya

enum MoviesService {
    case fetchMovies(page: Int)
    case fetchMovieDetail(movieId: Int)
    case fetchMovieCredits(movieId: Int)
    case fetchVideo(movieId: Int)
    case searchMovie(query: String)
}

extension MoviesService: TargetType {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .fetchMovies(_):
            return "/movie/top_rated"
            
        case .fetchMovieDetail(let movieId):
            return "/movie/\(movieId)"
            
        case .fetchMovieCredits(let movieId):
            return "/movie/\(movieId)/credits"
            
        case .fetchVideo(let movieId):
            return "/movie/\(movieId)/videos"
            
        case .searchMovie(_):
            return "/search/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMovies(_), .fetchMovieDetail(_), .fetchMovieCredits(_), .fetchVideo(_), .searchMovie(_):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchMovies(_), .searchMovie(_):
            let sampleData = GetTopRatedMoviewsResponseDTO(page: 1, results: nil, total_pages: 1)
            return sampleData.jsonEncoded ?? Data()
            
        case .fetchMovieDetail(_):
            let sampleData = Movie(id: 0, poster_path: "", overview: "", release_date: "", title: "", vote_average: 0.0, backdrop_path: "")
            return sampleData.jsonEncoded ?? Data()
            
        case .fetchMovieCredits(_):
            let sampleData = GetMovieCreditsResponseDTO(id: 1, cast: [])
            return sampleData.jsonEncoded ?? Data()
            
        case .fetchVideo(_):
            let sampleData = GetVideosResponseDTO(id: 1, results: [])
            return sampleData.jsonEncoded ?? Data()
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMovies(let page):
            return .requestParameters(parameters: ["api_key": ServiceConfiguration.api_key, "language": ServiceConfiguration.language, "page": page], encoding: URLEncoding.default)
            
        case .fetchMovieDetail(_), .fetchMovieCredits(_), .fetchVideo(_):
            return .requestParameters(parameters: ["api_key": ServiceConfiguration.api_key, "language": ServiceConfiguration.language], encoding: URLEncoding.default)
            
        case .searchMovie(let query):
            return .requestParameters(parameters: ["api_key": ServiceConfiguration.api_key, "language": ServiceConfiguration.language, "query": query], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK:- Helper methods
extension MoviesService: MoyaRequestWrapper {
    typealias Service = MoviesService

    static var provider = MoyaProvider<MoviesService>()
}

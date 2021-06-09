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
}

extension MoviesService: TargetType {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .fetchMovies(let page):
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMovies(_):
            return .get
        default:
            fatalError("Method must be defined!!")
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchMovies(_):
            let sampleData = GetTopRatedMoviewsResponseDTO(page: 1, results: nil, total_pages: 1)
            return sampleData.jsonEncoded ?? Data()
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMovies:
            return .requestPlain
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

//
//  PersonService.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import Foundation
import Moya

enum PersonService {
    case fetchPersonDetail(personId: Int)
    case fetchPersonMovieCredits(personId: Int)
}

extension PersonService: TargetType {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .fetchPersonDetail(let personId):
            return "/3/person/\(personId)"
            
        case .fetchPersonMovieCredits(let personId):
            return "3/person/\(personId)/movie_credits"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPersonDetail(_), .fetchPersonMovieCredits(_):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchPersonDetail(_):
            let sampleData = Person(id: 0, name: "", profile_path: "", cast_id: 0, biography: "")
            return sampleData.jsonEncoded ?? Data()
            
        case .fetchPersonMovieCredits(_):
            let sampleData = GetPersonMovieCreditsResponseDTO(id: 0, cast: [])
            return sampleData.jsonEncoded ?? Data()
        }
    }
    
    var task: Task {
        switch self {
        case .fetchPersonDetail(_), .fetchPersonMovieCredits(_):
            return .requestParameters(parameters: ["api_key": ServiceConfiguration.api_key, "language": ServiceConfiguration.language], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK:- Helper methods
extension PersonService: MoyaRequestWrapper {
    typealias Service = PersonService

    static var provider = MoyaProvider<PersonService>()
}

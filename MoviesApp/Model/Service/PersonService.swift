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
    case fetchPopularPeople(page: Int)
    case searchPerson(query: String)
}

extension PersonService: TargetType {
    var baseURL: URL {
        return ServiceConfiguration.apiBaseURL
    }
    
    var path: String {
        switch self {
        case .fetchPersonDetail(let personId):
            return "/person/\(personId)"
            
        case .fetchPersonMovieCredits(let personId):
            return "/person/\(personId)/movie_credits"
            
        case .fetchPopularPeople(_):
            return "/person/popular"
            
        case .searchPerson(_):
            return "/search/person"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPersonDetail(_), .fetchPersonMovieCredits(_), .fetchPopularPeople(_), .searchPerson(_):
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
            
        case .fetchPopularPeople(_), .searchPerson(_):
            let sampleData = GetPopularPeopleResponseDTO(results: [])
            return sampleData.jsonEncoded ?? Data()
        }
    }
    
    var task: Task {
        switch self {
        case .fetchPersonDetail(_), .fetchPersonMovieCredits(_):
            return .requestParameters(parameters: ["api_key": ServiceConfiguration.api_key, "language": ServiceConfiguration.language], encoding: URLEncoding.default)
            
        case .fetchPopularPeople(let page):
            return .requestParameters(parameters: ["api_key": ServiceConfiguration.api_key, "language": ServiceConfiguration.language, "page": page], encoding: URLEncoding.default)
            
        case .searchPerson(let query):
            return .requestParameters(parameters: ["api_key": ServiceConfiguration.api_key, "language": ServiceConfiguration.language, "query": query], encoding: URLEncoding.default)
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

//
//  MoyaRequestWrapper.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

import Moya

protocol MoyaRequestWrapper {
    associatedtype Service: TargetType
    
    static var provider: MoyaProvider<Service> { get }
    func request<T:Decodable>(responseDTO: T.Type, completion: @escaping (T) -> Void, error errorBlock: @escaping (String) -> Void)
}

extension MoyaRequestWrapper {
    func request<T:Decodable>(responseDTO: T.Type, completion: @escaping (T) -> Void, error errorBlock: @escaping (String) -> Void) {
        Self.provider.request(self as! Self.Service) { (result) in
            switch result {
            case let .success(response):
                do {
                    #if DEBUG
                    print("Moya request request & response")
                    print("API Request url: \(response.request?.url?.absoluteString ?? "")")
                    print("API Request path: \(response.request?.url?.path ?? "")")
                    print("API Request body:\n \(String(data: response.request?.httpBody ?? Data(), encoding: .utf8))")
                    print("API Response code: \(response.response?.statusCode ?? -1)")
                    print("API Response body:\n \(String(data: response.data, encoding: .utf8))")
                    #endif
                    let responseDTO = try response.filterSuccessfulStatusCodes().map(responseDTO)
                    completion(responseDTO)
                }
                catch {
                    let errorDTO = "Moya request wrapping catch block message"
                    errorBlock(errorDTO)
                }
            case .failure(_):
                errorBlock("")
            }
        }
    }
}

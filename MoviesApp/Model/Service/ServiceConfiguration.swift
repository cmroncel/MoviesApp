//
//  ServiceConfiguration.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

class ServiceConfiguration {
    static let apiBaseURL: URL = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(ServiceConfiguration.api_key)&language=\(ServiceConfiguration.language)&page=1")!
    static let api_key: String = "1b50036640932c71147cece0b5b726bb"
    static let language: String = "en-US"
}

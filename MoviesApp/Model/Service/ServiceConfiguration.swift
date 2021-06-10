//
//  ServiceConfiguration.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

class ServiceConfiguration {
    static let apiBaseURL: URL = URL(string: "https://api.themoviedb.org/")!
    static let api_key: String = "1b50036640932c71147cece0b5b726bb"
    static let language: String = "en-US"
    static let apiImageBaseURL: String = "https://image.tmdb.org/t/p/"
}

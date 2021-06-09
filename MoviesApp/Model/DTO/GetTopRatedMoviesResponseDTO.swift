//
//  GetTopRatedMoviesResponseDTO.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

struct GetTopRatedMoviewsResponseDTO: Codable {
    let page: Int?
    let results: [Movie]?
    let total_pages: Int?
}

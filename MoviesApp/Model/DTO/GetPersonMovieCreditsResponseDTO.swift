//
//  GetPersonMovieCreditsResponseDTO.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import Foundation

struct GetPersonMovieCreditsResponseDTO: Codable {
    let id: Int?
    let cast: [Movie]?
}

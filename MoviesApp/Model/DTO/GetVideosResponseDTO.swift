//
//  GetVideosResponseDTO.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import Foundation

struct GetVideosResponseDTO: Codable {
    let id: Int?
    let results: [Video]?
}

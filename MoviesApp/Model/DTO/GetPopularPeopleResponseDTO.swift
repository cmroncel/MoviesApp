//
//  GetPopularPeopleResponseDTO.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import Foundation

struct GetPopularPeopleResponseDTO: Codable {
    let results: [PersonItem]?
}

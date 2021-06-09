//
//  Movie.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

struct Movie: Codable {
    let id: Int?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    let original_title: String?
    let title: String?
    let vote_average: Double?
}

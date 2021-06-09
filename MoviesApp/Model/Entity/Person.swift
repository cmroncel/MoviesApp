//
//  Person.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

struct Person: Codable {
    let id: Int
    let profilePicture: String
    let name: String
    let biography: String
    let movieCredits: [String]
}

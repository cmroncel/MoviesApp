//
//  Encodable.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

extension Encodable {
    var jsonEncoded: Data? {
        get {
            return try? JSONEncoder().encode(self)
        }
    }
}

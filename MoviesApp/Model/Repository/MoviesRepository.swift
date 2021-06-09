//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

protocol MoviesRepository {
    func getMovies(page: Int, completion: @escaping ([Movie]) -> Void, error: @escaping (String) -> Void)
}

class DefaultMoviesRepository: MoviesRepository {
    func getMovies(page: Int, completion: @escaping ([Movie]) -> Void, error: @escaping (String) -> Void) {
        MoviesService.fetchMovies(page: page).request(responseDTO: GetTopRatedMoviewsResponseDTO.self) { (response) in
            completion(response.results ?? [])
        } error: { (errorDTO) in
            error("Fetching movies failed")
        }
    }
}

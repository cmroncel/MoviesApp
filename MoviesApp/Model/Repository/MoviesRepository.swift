//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation

protocol MoviesRepository {
    func getMovies(page: Int, completion: @escaping ([Movie]) -> Void, error: @escaping (String) -> Void)
    func getMovieDetail(movieId: Int, completion: @escaping (Movie) -> Void, error: @escaping (String) -> Void)
    func getCredits(movieId: Int, completion: @escaping ([Person]) -> Void, error: @escaping (String) -> Void)
    func getVideos(movieId: Int, completion: @escaping ([Video]) -> Void, error: @escaping (String) -> Void)
}

class DefaultMoviesRepository: MoviesRepository {
    func getMovies(page: Int, completion: @escaping ([Movie]) -> Void, error: @escaping (String) -> Void) {
        MoviesService.fetchMovies(page: page).request(responseDTO: GetTopRatedMoviewsResponseDTO.self) { (response) in
            completion(response.results ?? [])
        } error: { (errorDTO) in
            error("Fetching movies failed")
        }
    }
    
    func getMovieDetail(movieId: Int, completion: @escaping (Movie) -> Void, error: @escaping (String) -> Void) {
        MoviesService.fetchMovieDetail(movieId: movieId).request(responseDTO: Movie.self) { (movie) in
            completion(movie)
        } error: { (errorDTO) in
            error("Fetching movie detail failed")
        }
    }
    
    func getCredits(movieId: Int, completion: @escaping ([Person]) -> Void, error: @escaping (String) -> Void) {
        MoviesService.fetchMovieCredits(movieId: movieId).request(responseDTO: GetMovieCreditsResponseDTO.self) { (response) in
            completion(response.cast ?? [])
        } error: { (errorDTO) in
            error("Fetching movie credits failed")
        }
    }
    
    func getVideos(movieId: Int, completion: @escaping ([Video]) -> Void, error: @escaping (String) -> Void) {
        MoviesService.fetchVideo(movieId: movieId).request(responseDTO: GetVideosResponseDTO.self) { (response) in
            completion(response.results ?? [])
        } error: { (errorDTO) in
            error("Fetching movie videos failed")
        }
    }
}

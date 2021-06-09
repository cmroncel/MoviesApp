//
//  MainViewModel.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 10.06.2021.
//

import Foundation

class MainViewModel {
    // MARK:- Properties
    private let moviesRepository: MoviesRepository
    var movies: [Movie]?
    
    init(moviesRepository: MoviesRepository = DefaultMoviesRepository()) {
        self.moviesRepository = moviesRepository
    }
    
    func getMovies() {
        moviesRepository.getMovies(page: 1) {[weak self] (movies) in
            self?.movies = movies
        } error: {[weak self] (errorDTO) in
            print("Failed to getting movies")
        }
    }
}

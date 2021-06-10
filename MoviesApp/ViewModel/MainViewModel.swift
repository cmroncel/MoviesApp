//
//  MainViewModel.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 10.06.2021.
//

import Foundation

protocol MainViewModelDelegate: class {
    func pageContentUpdated()
}

class MainViewModel {
    // MARK:- Properties
    weak var delegate: MainViewModelDelegate?
    private let moviesRepository: MoviesRepository
    var movies: [Movie]?
    
    init(moviesRepository: MoviesRepository = DefaultMoviesRepository()) {
        self.moviesRepository = moviesRepository
    }
    
    func getMovies() {
        moviesRepository.getMovies(page: 2) {[weak self] (movies) in
            self?.movies = movies
            
            self?.delegate?.pageContentUpdated()
        } error: {[weak self] (errorDTO) in
            print("Failed to getting movies")
        }
    }
}

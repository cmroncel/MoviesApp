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

class MainViewModel: BaseViewModel {
    // MARK:- Properties
    weak var delegate: MainViewModelDelegate?
    private let moviesRepository: MoviesRepository
    
    var movies: [Movie]
    
    var moviesPage: Int
    var isPagingEnabled: Bool
    var isMovieListLoading: Bool
    
    init(moviesRepository: MoviesRepository = DefaultMoviesRepository(),
         movies: [Movie] = [],
         moviesPage: Int = 1,
         isPagingEnabled: Bool = true,
         isMovieListLoading: Bool = false) {
        self.moviesRepository = moviesRepository
        
        self.movies = movies
        
        self.moviesPage = moviesPage
        self.isPagingEnabled = isPagingEnabled
        self.isMovieListLoading = isMovieListLoading
    }
    
    override func viewWillAppear() {
        getMovies()
    }
    
    func getMovies() {
        if isMovieListLoading {
            return
        }
        
        if isPagingEnabled {
            baseVMDelegate?.contentWillLoad()
            
            isMovieListLoading = true
            
            moviesRepository.getMovies(page: moviesPage) {[weak self] (movies) in
                if movies.count == 0 {
                    self?.isPagingEnabled = false
                }
                
                self?.movies += movies
                
                self?.moviesPage += 1
                
                self?.isMovieListLoading = false
                
                self?.delegate?.pageContentUpdated()
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: {[weak self] (errorDTO) in
                print(errorDTO)
                
                self?.isMovieListLoading = false
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func updateMoviesList(indexPath: Int) {
        if indexPath == movies.count - 1 {
            guard isPagingEnabled else {
                return
            }
            
            getMovies()
        }
    }
    
    func clearMoviesList() {
        isPagingEnabled = true
        moviesPage = 1
        movies = []
        isMovieListLoading = false
    }
}

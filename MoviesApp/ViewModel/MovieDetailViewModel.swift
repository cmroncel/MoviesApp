//
//  MovieDetailViewModel.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 11.06.2021.
//

import Foundation
protocol MovieDetailViewModelDelegate: class {
    func movieDetailUpdated(movie: Movie)
    func castMembersUpdated()
    func videosUpdated()
}

class MovieDetailViewModel: BaseViewModel {
    // MARK:- Properties
    weak var delegate: MovieDetailViewModelDelegate?
    private let moviesRepository: MoviesRepository
    var movieId: Int?
    var castMembers: [Person]
    var videos: [Video]
    
    init(moviesRepository: MoviesRepository = DefaultMoviesRepository(),
         castMembers: [Person] = [],
         videos: [Video] = []) {
        self.moviesRepository = moviesRepository
        self.castMembers = castMembers
        self.videos = videos
    }
    
    override func viewWillAppear() {
        getMovieDetail()
        getCastMembers()
        getVideos()
    }
    
    private func getMovieDetail() {
        if let movieId = movieId {
            baseVMDelegate?.contentWillLoad()
            
            self.moviesRepository.getMovieDetail(movieId: movieId) {[weak self] (movie) in
                self?.delegate?.movieDetailUpdated(movie: movie)
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: {[weak self] (errorDTO) in
                print(errorDTO)
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    private func getCastMembers() {
        if let movieId = movieId {
            baseVMDelegate?.contentWillLoad()
            
            self.moviesRepository.getCredits(movieId: movieId) {[weak self] (castMembers) in
                self?.castMembers = castMembers
                
                self?.delegate?.castMembersUpdated()
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: { (errorDTO) in
                print(errorDTO)
                
                self.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    private func getVideos() {
        if let movieId = movieId {
            baseVMDelegate?.contentWillLoad()
            
            self.moviesRepository.getVideos(movieId: movieId) {[weak self] (videos) in
                self?.videos = videos
                
                self?.delegate?.videosUpdated()
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: {[weak self] (errorDTO) in
                print(errorDTO)
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
}

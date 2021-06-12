//
//  MovieDetailViewModel.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 11.06.2021.
//

import Foundation
protocol MovieDetailViewModelDelegate: class {
    func pageContentUpdated()
}

class MovieDetailViewModel: BaseViewModel {
    // MARK:- Properties
    weak var delegate: MovieDetailViewModelDelegate?
    private let moviesRepository: MoviesRepository
    var movieId: Int?
    var castMembers: [Person]
    var videos: [Video]
    var movie: Movie?
    
    private var dispatchGroup: DispatchGroup?
    private var isPageContentFailed: Bool
    private var errorDTO: String?
    
    init(moviesRepository: MoviesRepository = DefaultMoviesRepository(),
         castMembers: [Person] = [],
         videos: [Video] = []) {
        self.moviesRepository = moviesRepository
        self.castMembers = castMembers
        self.videos = videos
        
        self.isPageContentFailed = false
    }
    
    override func viewWillAppear() {
        loadData()
    }
    
    private func loadData() {
        if let movieId = movieId {
            self.baseVMDelegate?.contentWillLoad()
            
            dispatchGroup = DispatchGroup()
            dispatchGroup?.enter()
            
            isPageContentFailed = false
            
            // Get Movie Detail
            self.moviesRepository.getMovieDetail(movieId: movieId) {[weak self] (movie) in
                self?.movie = movie
                
                self?.dispatchGroup?.leave()
            } error: {[weak self] (errorDTO) in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                
                self?.dispatchGroup?.leave()
            }
            
            dispatchGroup?.enter()
            // Get Videos
            self.moviesRepository.getVideos(movieId: movieId) {[weak self] (videos) in
                self?.videos = videos
                
                self?.dispatchGroup?.leave()
            } error: {[weak self] (errorDTO) in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                
                self?.dispatchGroup?.leave()
            }
            
            dispatchGroup?.enter()
            // Get Cast Members
            self.moviesRepository.getCredits(movieId: movieId) {[weak self] (castMembers) in
                self?.castMembers = castMembers
                
                self?.dispatchGroup?.leave()
            } error: {[weak self] (errorDTO) in
                self?.baseVMDelegate?.contentDidLoad()
                
                self?.errorDTO = errorDTO
                self?.isPageContentFailed = true
                
                self?.dispatchGroup?.leave()
            }
            
            dispatchGroup?.notify(queue: .main, execute: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                if strongSelf.isPageContentFailed {
                    print(self?.errorDTO)
                }
                else {
                    self?.delegate?.pageContentUpdated()
                }
                
                self?.baseVMDelegate?.contentDidLoad()
            })
        }
    }
}

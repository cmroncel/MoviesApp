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
    private let personRepository: PersonRepository
    
    var movies: [Movie]
    var personItems: [PersonItem]
    
    var page: Int
    var isPagingEnabled: Bool
    var isListLoading: Bool
    
    init(moviesRepository: MoviesRepository = DefaultMoviesRepository(),
         personRepository: PersonRepository = DefaultPersonRepository(),
         movies: [Movie] = [],
         personItems: [PersonItem] = [],
         page: Int = 1,
         isPagingEnabled: Bool = true,
         isListLoading: Bool = false) {
        self.moviesRepository = moviesRepository
        self.personRepository = personRepository
        
        self.movies = movies
        self.personItems = personItems
        
        self.page = page
        self.isPagingEnabled = isPagingEnabled
        self.isListLoading = isListLoading
    }
    
    override func viewDidDisappear() {
        clearList()
    }
    
    func getMovies() {
        if isListLoading {
            return
        }
        
        if isPagingEnabled {
            baseVMDelegate?.contentWillLoad()
            
            isListLoading = true
            
            moviesRepository.getMovies(page: page) {[weak self] (movies) in
                if movies.count == 0 {
                    self?.isPagingEnabled = false
                }
                
                self?.movies += movies
                
                self?.page += 1
                
                self?.isListLoading = false
                
                self?.delegate?.pageContentUpdated()
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: {[weak self] (errorDTO) in
                print(errorDTO)
                
                self?.isListLoading = false
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func getPopularPeople() {
        if isListLoading {
            return
        }
        
        if isPagingEnabled {
            baseVMDelegate?.contentWillLoad()
            
            isListLoading = true
            
            personRepository.getPopularPeople(page: page) {[weak self] (personItems) in
                if personItems.count == 0 {
                    self?.isPagingEnabled = false
                }
                
                self?.personItems += personItems
                
                self?.page += 1
                
                self?.isListLoading = false
                
                self?.delegate?.pageContentUpdated()
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: {[weak self] (errorDTO) in
                print(errorDTO)
                
                self?.isListLoading = false
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    func searchMovie(query: String) {
        baseVMDelegate?.contentWillLoad()
        
        moviesRepository.searchMovies(query: query) {[weak self] (movies) in
            self?.clearList()
            
            self?.movies = movies
            self?.isPagingEnabled = false
            
            self?.delegate?.pageContentUpdated()
            
            self?.baseVMDelegate?.contentDidLoad()
        } error: {[weak self] (errorDTO) in
            print(errorDTO)
            
            self?.baseVMDelegate?.contentDidLoad()
        }
    }
    
    func searchPerson(query: String) {
        baseVMDelegate?.contentWillLoad()
        
        personRepository.searchPerson(query: query) {[weak self](personItems) in
            self?.clearList()
            
            self?.personItems = personItems
            self?.isPagingEnabled = false
            
            self?.delegate?.pageContentUpdated()
            
            self?.baseVMDelegate?.contentDidLoad()
        } error: { (errorDTO) in
            print(errorDTO)
            
            self.baseVMDelegate?.contentDidLoad()
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
    
    func updatePopulerPeopleList(indexPath: Int) {
        if indexPath == personItems.count - 1 {
            guard isPagingEnabled else {
                return
            }
            
            getPopularPeople()
        }
    }
    
    func clearList() {
        isPagingEnabled = true
        page = 1
        movies = []
        personItems = []
        isListLoading = false
    }
}

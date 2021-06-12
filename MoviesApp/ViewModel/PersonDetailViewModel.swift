//
//  PersonDetailViewModel.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import Foundation

protocol PersonDetailViewModelDelegate: class {
    func pageContentUpdated(person: Person)
    func movieCreditsUpdated()
}

class PersonDetailViewModel: BaseViewModel {
    // MARK:- Properties
    weak var delegate: PersonDetailViewModelDelegate?
    private var personRepository: PersonRepository
    var personId: Int?
    var movieCredits: [Movie]
    
    init(personRepository: PersonRepository = DefaultPersonRepository(),
         movieCredits: [Movie] = []) {
        self.personRepository = personRepository
        self.movieCredits = movieCredits
    }
    
    override func viewWillAppear() {
        getPersonDetail()
        getPersonMovieCredits()
    }
    
    private func getPersonDetail() {
        if let personId = personId {
            self.baseVMDelegate?.contentWillLoad()
            
            personRepository.getPersonDetail(personId: personId) {[weak self] (person) in
                self?.delegate?.pageContentUpdated(person: person)
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: {[weak self] (errorDTO) in
                print(errorDTO)
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
    
    private func getPersonMovieCredits() {
        if let personId = personId {
            self.baseVMDelegate?.contentWillLoad()
            
            personRepository.getPersonMovieCredits(personId: personId) {[weak self] (movieCredits) in
                self?.movieCredits = movieCredits
                
                self?.delegate?.movieCreditsUpdated()
                
                self?.baseVMDelegate?.contentDidLoad()
            } error: {[weak self] (errorDTO) in
                print(errorDTO)
                
                self?.baseVMDelegate?.contentDidLoad()
            }
        }
    }
}

//
//  PersonRepository.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import Foundation

protocol PersonRepository {
    func getPersonDetail(personId: Int, completion: @escaping (Person) -> Void, error: @escaping (String) -> Void)
    func getPersonMovieCredits(personId: Int, completion: @escaping ([Movie]) -> Void, error: @escaping (String) -> Void)
}

class DefaultPersonRepository: PersonRepository {
    func getPersonDetail(personId: Int, completion: @escaping (Person) -> Void, error: @escaping (String) -> Void) {
        PersonService.fetchPersonDetail(personId: personId).request(responseDTO: Person.self) { (person) in
            completion(person)
        } error: { (errorDTO) in
            error("Fetching person detail failed")
        }
    }
    
    func getPersonMovieCredits(personId: Int, completion: @escaping ([Movie]) -> Void, error: @escaping (String) -> Void) {
        PersonService.fetchPersonMovieCredits(personId: personId).request(responseDTO: GetPersonMovieCreditsResponseDTO.self) { (response) in
            completion(response.cast ?? [])
        } error: { (errorDTO) in
            error("Fetching person movie credits failed")
        }
    }
}

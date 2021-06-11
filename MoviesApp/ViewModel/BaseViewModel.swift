//
//  BaseViewModel.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 11.06.2021.
//

import Foundation

protocol BaseViewModelDelegate: class {
    func contentWillLoad()
    func contentDidLoad()
}

class BaseViewModel: NSObject {
    // MARK:- Properties
    weak var baseVMDelegate: BaseViewModelDelegate?
    
    func viewDidLoad() {}
    
    func viewWillAppear() {}
    
    func viewDidAppear() {}
    
    func viewWillDisappear() {}
    
    func viewDidDisappear() {}
}

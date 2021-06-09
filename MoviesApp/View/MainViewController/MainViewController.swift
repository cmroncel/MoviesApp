//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import UIKit

class MainViewController: UIViewController {
    // MARK:- Properties
    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.getMovies()
    }
}

// MARK:- Creator
extension MainViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "MainViewController"
        }
    }
    
    class func create() -> MainViewController {
        let vc: MainViewController = MainViewController.instantiateFromNib()
        let viewModel: MainViewModel = MainViewModel()
        vc.viewModel = viewModel
        
        return vc
    }
}

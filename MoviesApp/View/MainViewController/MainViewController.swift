//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//
import Foundation
import UIKit

class MainViewController: UIViewController {
    // MARK:- Properties
    var viewModel: MainViewModel?

    // MARK:- Views
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel?.getMovies()
        initUI()
    }
    
    // MARK:- UI Methods
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        MovieCell.registerSelf(tableView: tableView)
    }
}

// MARK:- UITableViewDelegate & UITableViewDataSource Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        if let movies = viewModel?.movies {
            cell.bind(movieItem: movies[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

// MARK:- MainViewModelDelegate Methods
extension MainViewController: MainViewModelDelegate {
    func pageContentUpdated() {
        tableView.reloadData()
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
        viewModel.delegate = vc
        
        return vc
    }
}

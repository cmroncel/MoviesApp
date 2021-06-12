//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//
import Foundation
import UIKit

class MainViewController: BaseViewController {
    // MARK:- Properties
    var viewModel: MainViewModel!

    // MARK:- Views
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.getMovies()
        }
        else {
            viewModel.getPopularPeople()
        }
    }
    
    // MARK:- UI Methods
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        MovieCell.registerSelf(tableView: tableView)
        PopularPeopleCell.registerSelf(tableView: tableView)
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        viewModel.clearList()
        
        searchBar.text = nil
        
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.getMovies()
        }
        else {
            viewModel.getPopularPeople()
        }
    }
}

// MARK:- UISearchBarDelegate Methods
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        viewModel.clearList()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if let query = searchBar.text {
                if query.count < 1 {
                    viewModel.isPagingEnabled = true
                    viewModel.getMovies()
                }
                else {
                    viewModel.searchMovie(query: query)
                }
            }
        }
        else {
            if let query = searchBar.text {
                if query.count < 1 {
                    viewModel.isPagingEnabled = true
                    viewModel.getPopularPeople()
                }
                else {
                    viewModel.searchPerson(query: query)
                }
            }
        }
    }
}

// MARK:- UITableViewDelegate & UITableViewDataSource Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return viewModel.movies.count
        }
        else {
            return viewModel.personItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
            cell.bind(movieItem: viewModel.movies[indexPath.row])
            
            viewModel.updateMoviesList(indexPath: indexPath.row)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularPeopleCell") as! PopularPeopleCell
            cell.bind(personItem: viewModel.personItems[indexPath.row])
            
            viewModel.updatePopulerPeopleList(indexPath: indexPath.row)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0, let movieId = viewModel.movies[indexPath.row].id {
            let vc: MovieDetailViewController = MovieDetailViewController.create(movieId: movieId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if let personId = viewModel.personItems[indexPath.row].id {
            let vc: PersonDetailViewController = PersonDetailViewController.create(personId: personId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

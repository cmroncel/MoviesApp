//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 11.06.2021.
//

import UIKit
import AlamofireImage
import SafariServices

class MovieDetailViewController: BaseViewController {
    // MARK:- Properties
    var viewModel: MovieDetailViewModel!
    
    // MARK:- Views
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var averageVoteLabel: UILabel!
    @IBOutlet weak var castMembersCollectionView: UICollectionView!
    @IBOutlet weak var videosTableView: UITableView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK:- UI Methods
    private func initUI() {
        videosTableView.delegate = self
        videosTableView.dataSource = self
        
        TrailersTableViewCell.registerSelf(tableView: videosTableView)
        
        castMembersCollectionView.dataSource = self
        castMembersCollectionView.delegate = self
        
        CastCollectionViewCell.registerSelf(collectionView: castMembersCollectionView)
        
        setCollectionViewLayout()
    }
    
    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        self.castMembersCollectionView.collectionViewLayout = layout
        
        castMembersCollectionView.reloadData()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- UITableViewDelegate & UITableViewDataSource Methods
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailersTableViewCell", for: indexPath) as! TrailersTableViewCell
        
        if let name = viewModel.videos[indexPath.row].name {
            cell.bind(name: name)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let key = viewModel.videos[indexPath.row].key {
            guard let url = URL(string: "https://www.youtube.com/watch?v=\(key)") else {
                return
            }
            
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK:- UICollectionViewDataSource & UICollectionViewDelegate Methods
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.castMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
        
        if let name = viewModel.castMembers[indexPath.row].name, let imageUrl = viewModel.castMembers[indexPath.row].profile_path {
            cell.bind(name: name, imageUrl: imageUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let personId = viewModel.castMembers[indexPath.row].id {
            let vc: PersonDetailViewController = PersonDetailViewController.create(personId: personId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK:- MovieDetailViewModelDelegate Methods
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func pageContentUpdated() {
        if let movie = viewModel.movie {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                if let coverPhoto = movie.backdrop_path, let iconUrl = URL(string: ServiceConfiguration.apiImageBaseURL + "w500" + coverPhoto) {
                    let filter = AspectScaledToFillSizeFilter(size: strongSelf.coverImageView.bounds.size)
                    strongSelf.coverImageView.af.setImage(withURL: iconUrl, filter: filter)
                }
            }
            
            titleLabel.text = movie.title
            overviewTextView.text = movie.overview
            averageVoteLabel.text = String(movie.vote_average ?? 0)
        }
        
        castMembersCollectionView.reloadData()
        videosTableView.reloadData()
    }
}

// MARK:- Creator
extension MovieDetailViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "MovieDetailViewController"
        }
    }
    
    class func create(movieId: Int) -> MovieDetailViewController {
        let vc: MovieDetailViewController = MovieDetailViewController.instantiateFromNib()
        let viewModel: MovieDetailViewModel = MovieDetailViewModel()
        
        vc.viewModel = viewModel
        
        viewModel.delegate = vc
        viewModel.movieId = movieId
        
        return vc
    }
}

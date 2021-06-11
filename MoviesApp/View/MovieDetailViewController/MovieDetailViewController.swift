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
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var averageVoteLabel: UILabel!
    @IBOutlet weak var trailersLabel: UILabel!
    @IBOutlet weak var trailersCollectionView: UICollectionView!
    @IBOutlet weak var castMembersCollectionView: UICollectionView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK:- UI Methods
    private func initUI() {
        castMembersCollectionView.dataSource = self
        castMembersCollectionView.delegate = self
        
        trailersCollectionView.dataSource = self
        trailersCollectionView.delegate = self
        
        CastCollectionViewCell.registerSelf(collectionView: castMembersCollectionView)
        TrailersCollectionViewCell.registerSelf(collectionView: trailersCollectionView)
        
        castMembersCollectionView.reloadData()
        trailersCollectionView.reloadData()
        
        setCollectionViewLayout()
    }
    
    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        self.castMembersCollectionView.collectionViewLayout = layout
        self.castMembersCollectionView.reloadData()
        
        self.trailersCollectionView.collectionViewLayout = layout
        self.trailersCollectionView.reloadData()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- UICollectionViewDataSource & UICollectionViewDelegate Methods
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castMembersCollectionView {
            return viewModel.castMembers.count
        }
        else {
            return viewModel.videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castMembersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
            
            if let name = viewModel.castMembers[indexPath.row].name, let imageUrl = viewModel.castMembers[indexPath.row].profile_path {
                cell.bind(name: name, imageUrl: imageUrl)
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrailersCollectionViewCell", for: indexPath) as! TrailersCollectionViewCell
            
            if let name = viewModel.videos[indexPath.row].name {
                cell.bind(name: name)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trailersCollectionView {
            if let key = viewModel.videos[indexPath.row].key {
                guard let url = URL(string: "https://www.youtube.com/watch?v=\(key)") else {
                    return
                }
                
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

// MARK:- MovieDetailViewModelDelegate Methods
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func movieDetailUpdated(movie: Movie) {
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
        overviewLabel.text = movie.overview
        averageVoteLabel.text = String(movie.vote_average ?? 0)
    }
    
    func castMembersUpdated() {
        castMembersCollectionView.reloadData()
    }
    
    func videosUpdated() {
        trailersCollectionView.reloadData()
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

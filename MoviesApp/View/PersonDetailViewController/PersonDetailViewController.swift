//
//  PersonDetailViewController.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import UIKit
import AlamofireImage

class PersonDetailViewController: BaseViewController {
    // MARK:- Properties
    var viewModel: PersonDetailViewModel!
    
    // MARK:- Views
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var movieCreditsCollectionView: UICollectionView!
    
    override func provideViewModel() -> BaseViewModel? {
        return viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    // MARK:- UI Methods
    private func initUI() {
        movieCreditsCollectionView.dataSource = self
        movieCreditsCollectionView.delegate = self
        
        PersonMovieCreditsCollectionViewCell.registerSelf(collectionView: movieCreditsCollectionView)
        
        setCollectionViewLayout()
    }
    
    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        self.movieCreditsCollectionView.collectionViewLayout = layout
        
        movieCreditsCollectionView.reloadData()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- UICollectionViewDataSource & UICollectionViewDelegate Methods
extension PersonDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieCredits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonMovieCreditsCollectionViewCell", for: indexPath) as! PersonMovieCreditsCollectionViewCell
        
        if let name = viewModel.movieCredits[indexPath.row].title, let imageUrl = viewModel.movieCredits[indexPath.row].poster_path {
            cell.bind(name: name, imageUrl: imageUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = viewModel.movieCredits[indexPath.row].id {
            let vc: MovieDetailViewController = MovieDetailViewController.create(movieId: movieId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK:- PersonDetailViewModelDelegate Methods
extension PersonDetailViewController: PersonDetailViewModelDelegate {
    func pageContentUpdated(person: Person) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if let profilePhoto = person.profile_path, let iconUrl = URL(string: ServiceConfiguration.apiImageBaseURL + "w500" + profilePhoto) {
                let filter = AspectScaledToFitSizeFilter(size: strongSelf.profileImageView.bounds.size)
                strongSelf.profileImageView.af.setImage(withURL: iconUrl, filter: filter)
            }
        }
        
        nameLabel.text = person.name
        biographyTextView.text = person.biography
    }
    
    func movieCreditsUpdated() {
        movieCreditsCollectionView.reloadData()
    }
}

// MARK:- Creator
extension PersonDetailViewController: XibNameProvider {
    static var xibName: String {
        get {
            return "PersonDetailViewController"
        }
    }
    
    class func create(personId: Int) -> PersonDetailViewController {
        let vc: PersonDetailViewController = PersonDetailViewController.instantiateFromNib()
        let viewModel: PersonDetailViewModel = PersonDetailViewModel()
        
        vc.viewModel = viewModel
        
        viewModel.delegate = vc
        viewModel.personId = personId
        
        return vc
    }
}

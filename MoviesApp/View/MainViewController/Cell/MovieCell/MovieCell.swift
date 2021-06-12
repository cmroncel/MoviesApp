//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 10.06.2021.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
    // MARK:- Views
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var averageVoteLabel: UILabel!
    
    func bind(movieItem: Movie) {
        posterImageView.af.cancelImageRequest()
        posterImageView.image = UIImage()
        
        titleLabel.text = movieItem.title
        releaseDateLabel.text = movieItem.release_date
        averageVoteLabel.text = String(movieItem.vote_average ?? 0.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if let posterPath = movieItem.poster_path, let iconUrl = URL(string: ServiceConfiguration.apiImageBaseURL + "w400" + posterPath) {
                let filter = AspectScaledToFitSizeFilter(size: strongSelf.posterImageView.bounds.size)
                strongSelf.posterImageView.af.setImage(withURL: iconUrl, filter: filter)
            }
        }
    }
}

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
        // Set title, relase date and average vote
        containerView.layer.cornerRadius = 10
        titleLabel.text = movieItem.title
        releaseDateLabel.text = movieItem.release_date
        averageVoteLabel.text = String(movieItem.vote_average ?? 0.0)
        
        // Set image process
        if let posterPath = movieItem.poster_path, let iconUrl = URL(string: ServiceConfiguration.apiImageBaseURL + "w400" + posterPath) {
            let filter = AspectScaledToFitSizeFilter(size: posterImageView.bounds.size)
            posterImageView.af.setImage(withURL: iconUrl, filter: filter)
        }
    }
}

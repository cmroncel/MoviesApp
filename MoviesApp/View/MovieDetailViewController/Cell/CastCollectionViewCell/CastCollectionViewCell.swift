//
//  CastCollectionViewCell.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import UIKit
import AlamofireImage

class CastCollectionViewCell: UICollectionViewCell {
    // MARK:- Views
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    func bind(name: String, imageUrl: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if let iconUrl = URL(string: ServiceConfiguration.apiImageBaseURL + "w400" + imageUrl) {
                let filter = AspectScaledToFillSizeCircleFilter(size: strongSelf.profileImageView.bounds.size)
                strongSelf.profileImageView.af.setImage(withURL: iconUrl, filter: filter)
            }
        }
        
        nameLabel.text = name
    }
}

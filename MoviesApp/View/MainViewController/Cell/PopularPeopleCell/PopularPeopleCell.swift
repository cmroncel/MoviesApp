//
//  PopularPeopleCell.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import UIKit
import AlamofireImage

class PopularPeopleCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func bind(personItem: PersonItem) {
        profileImageView.af.cancelImageRequest()
        profileImageView.image = UIImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if let profilePath = personItem.profile_path, let iconUrl = URL(string: ServiceConfiguration.apiImageBaseURL + "w400" + profilePath) {
                let filter = AspectScaledToFitSizeFilter(size: strongSelf.profileImageView.bounds.size)
                strongSelf.profileImageView.af.setImage(withURL: iconUrl, filter: filter)
            }
        }
        
        nameLabel.text = personItem.name
    }
}

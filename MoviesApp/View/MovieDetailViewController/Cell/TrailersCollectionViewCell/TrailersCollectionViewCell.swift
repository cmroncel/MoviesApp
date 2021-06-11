//
//  TrailersCollectionViewCell.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import UIKit

class TrailersCollectionViewCell: UICollectionViewCell {
    // MARK:- Views
    @IBOutlet weak var nameLabel: UILabel!
    
    func bind(name: String) {
        nameLabel.text = name
    }
}

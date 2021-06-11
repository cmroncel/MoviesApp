//
//  UICollectionViewCell.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 12.06.2021.
//

import UIKit

extension UICollectionViewCell {
    class func registerSelf(collectionView: UICollectionView) {
        let nib = UINib(nibName: self.className, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: self.className)
    }
}

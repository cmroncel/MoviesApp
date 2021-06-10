//
//  UITableViewCell.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 10.06.2021.
//

import Foundation
import UIKit

extension UITableViewCell {
    class func registerSelf(tableView: UITableView) {
        let nib = UINib(nibName: self.className, bundle: Bundle(for: self))
        tableView.register(nib, forCellReuseIdentifier: self.className)
    }
}

//
//  UIViewController.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import Foundation
import UIKit

public extension UIViewController {
    typealias XibVC = UIViewController & XibNameProvider
    static func instantiateFromNib<T: XibVC>() -> T {
        return T.init(nibName: T.xibName, bundle: Bundle(for: T.self))
    }
}

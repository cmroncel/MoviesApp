//
//  AppDelegate.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 9.06.2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var window: UIWindow?
    lazy var rootNavigationController: UINavigationController = window?.rootViewController as! UINavigationController

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        // Set root vc
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        return true
    }
}

// MARK:- Root VC Provider
extension AppDelegate {
    private func getRootViewController() -> UIViewController {
        let launchVC: MainViewController = MainViewController.create()
        let navController = UINavigationController(rootViewController: launchVC)
        navController.navigationBar.isHidden = true
        navController.interactivePopGestureRecognizer?.isEnabled = false
        navController.interactivePopGestureRecognizer?.delegate = nil
        navController.view.backgroundColor = .white
        return navController
    }
}


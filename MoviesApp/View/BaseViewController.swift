//
//  BaseViewController.swift
//  MoviesApp
//
//  Created by Cemre Öncel on 11.06.2021.
//

import Foundation
import JGProgressHUD

class BaseViewController: UIViewController, BaseViewModelDelegate {
    // MARK:- Properties
    private var viewModel: BaseViewModel!
    private var progressViewCount: Int = 0
    
    // MARK:- Views
    private let progressHUD = JGProgressHUD(style: .light)
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let baseVM = provideViewModel() else {
            fatalError("A view model must be provided")
        }
        
        viewModel = baseVM
        viewModel.baseVMDelegate = self
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDisappear()
    }
    
    // MARK:- BaseViewModel Provider
    func provideViewModel() -> BaseViewModel? {
        return nil
    }
    
    // MARK:- BaseViewModelDelegate
    func readyForContent() {
    }
    
    func contentDidLoad() {
        progressViewCount -= 1

        guard progressViewCount == 0 else {
            return
        }
        
        progressHUD.dismiss()
    }
    
    func contentWillLoad() {
        progressViewCount += 1
        
        guard progressViewCount == 1 else {
            return
        }
        
        progressHUD.show(in: self.view)
    }
}

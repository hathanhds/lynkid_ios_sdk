//
//  SplashScreenViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    var navigator: Navigator!
    var viewModel: SplashScreenViewModel!
    
    
    class func create(with navigator: Navigator, viewModel: SplashScreenViewModel) -> SplashScreenViewController {
        let vc = UIStoryboard.splashScreen.instantiateViewController(ofType: SplashScreenViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    
    func bind(to viewModel: SplashScreenViewModel) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigator.show(segue: .main) { [weak self ] vc in
            self?.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

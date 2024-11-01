//
//  UserInfoViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    private var viewModel: UserInfoViewModel!
    private var navigator: Navigator!
    
    class func create(with navigator: Navigator, viewModel: UserInfoViewModel) -> UserInfoViewController {
        let vc = UIStoryboard.userInfo.instantiateViewController(ofType: UserInfoViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        
    }
    
    func bind(to viewModel: UserInfoViewModel) {
        
    }
}

//
//  MainTabBarViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var viewModel: MainTabBarViewModel!
    var navigator: Navigator!

    class func create(with navigator: Navigator, viewModel: MainTabBarViewModel) -> MainTabBarController {
        let vc = UIStoryboard.main.instantiateViewController(ofType: MainTabBarController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }

    private func setUpViews() {
        // Home
        let homeVC = HomeViewController.create(with: navigator,
            viewModel: HomeViewModel(newsRepository: NewsRepositoryImpl(),
                giftsRepository: GiftsRepositoryImpl(),
                userRepository: UserRepositoryImpl())
        )
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Trang chủ",
            image: .iconTabHomeInactive?.withRenderingMode(.alwaysOriginal),
            selectedImage: .iconTabHomeActive?.withRenderingMode(.alwaysOriginal))

        let viewMode = AppConfig.shared.viewMode
        // MyReward
        let myRewardVC = viewMode == .anonymous ? AnonymousViewController.create(with: self.navigator, viewModel: AnonymousViewModel(title: "Quà của tôi"))
        : MyRewardViewController.create(with: self.navigator, viewModel: MyRewardViewModel(giftsRepository: GiftsRepositoryImpl()))
        let myrewardNav = UINavigationController(rootViewController: myRewardVC)
        myrewardNav.tabBarItem = UITabBarItem(title: "Quà của tôi",
            image: .iconTabRewardInactive?.withRenderingMode(.alwaysOriginal),
            selectedImage: .iconTabRewardActive?.withRenderingMode(.alwaysOriginal))

        // Transaction History
        let transactionHistoryVC = viewMode == .anonymous ? AnonymousViewController.create(with: self.navigator, viewModel: AnonymousViewModel(title: "Lịch sử"))
        : TransactionHistoryViewController.create(with: self.navigator, viewModel: TransactionHistoryViewModel(merchantRepository: MerchantRepositoryImp()))
        let transactionHistoryNav = UINavigationController(rootViewController: transactionHistoryVC)
        transactionHistoryNav.tabBarItem = UITabBarItem(title: "Lịch sử",
            image: .iconTabTransactionInactive?.withRenderingMode(.alwaysOriginal),
            selectedImage: .iconTabTransactionActive?.withRenderingMode(.alwaysTemplate))

        // UserInfo
        let userInfoVC = InstallAppPopupViewController.create(with: navigator, viewModel: InstallAppPopupViewModel(isTabbar: true))
        let userInfoNav = UINavigationController(rootViewController: userInfoVC)
        userInfoNav.navigationBar.isHidden = true
        userInfoNav.tabBarItem = UITabBarItem(title: "Tài khoản",
            image: .iconTabAccountInactive?.withRenderingMode(.alwaysOriginal),
            selectedImage: .iconTabAccountActive?.withRenderingMode(.alwaysOriginal))


        self.viewControllers = [homeNav, myrewardNav, transactionHistoryNav, userInfoNav]

    }

    func configureUI() {
        self.tabBar.tintColor = .mainColor
        self.tabBar.backgroundColor = .white
        self.tabBar.unselectedItemTintColor = .cA7A7B3
        self.view.backgroundColor = .white

        self.tabBar.layer.masksToBounds = false
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.isTranslucent = false

        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        self.tabBar.layer.shadowOpacity = 0.13
        self.tabBar.layer.shadowRadius = 20
    }
}

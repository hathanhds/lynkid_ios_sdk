//
//  MyRewardListViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit
import RxSwift
import Tabman
import Pageboy

class MyRewardViewController: TabmanViewController {

    var navigator: Navigator!
    var viewModel: MyRewardViewModel!
    var gradientView: UIView?
    var gradientImageView: UIImageView?

    class func create(with navigator: Navigator, viewModel: MyRewardViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: MyRewardViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    private var viewControllers: [BaseViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        initView()
        initTabView()
        setupGradientViewBehindBars()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func initView() {
        self.title = "Quà của tôi"
        viewControllers = [
            MyOwnedRewardViewController.create(with: self.navigator, viewModel: MyOwnedRewardViewModel(myrewardRepository: MyrewardRepositoryImpl())),
            MyUsedRewardViewController.create(with: self.navigator, viewModel: MyUsedRewardViewModel(myrewardRepository: MyrewardRepositoryImpl()))
        ];
    }

    func initTabView() {
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear // Makes the background clear // Set your custom background color
        bar.layout.transitionStyle = .snap // How the bar changes between tabs
        bar.layout.contentMode = .fit // Other options include .intrinsic

        // Customize the bar buttons
        bar.buttons.customize { (button) in
            button.tintColor = .white // Color for non-selected items
            button.selectedTintColor = .cFFCC00 // Color for selected item
            button.font = .f14r! // Choose your font here
            button.selectedFont = .f14s! // Choose your selected item font here
        }

        // Customize the bar indicator
        bar.indicator.tintColor = .cFFCC00 // Set to the color you require
        bar.indicator.weight = .custom(value: 2) // Set your desired indicator height

        // Customize the spacing and insets if necessary
        bar.layout.interButtonSpacing = 20 // Set the space between the buttons if needed
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Adjust the insets

        // Add the bar to the view controller
        addBar(bar, dataSource: self, at: .top)
    }
}


extension MyRewardViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var title = ""
        if(index == 0) {
            title = "Chưa sử dụng"
        } else if(index == 1) {
            title = "Đã sử dụng/ Hết hạn"
        }
        return TMBarItem(title: title)
    }
}

//
//  TransactionHistoryViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit
import RxSwift
import Tabman
import Pageboy

class TransactionHistoryViewController: TabmanViewController {

    private var navigator: Navigator!
    private var viewModel: TransactionHistoryViewModel!

    class func create(with navigator: Navigator, viewModel: TransactionHistoryViewModel) -> TransactionHistoryViewController {
        let vc = UIStoryboard.transactionHistory.instantiateViewController(ofType: TransactionHistoryViewController.self)
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
        self.showNavigationBar()
        setupTransparentNavigationBar()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func initTabView() {
        self.dataSource = self
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear // Makes the background clear // Set your custom background color
        bar.layout.transitionStyle = .snap // How the bar changes between tabs
        bar.layout.contentMode = .fit // Other options include .intrinsic
        bar.backgroundColor = .clear

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
        bar.layout.interButtonSpacing = 10 // Set the space between the buttons if needed
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Adjust the insets

        bar.setCommonGradient()
        // Add the bar to the view controller
        addBar(bar, dataSource: self, at: .top)
    }

    func initView() {
        self.title = "Lịch sử giao dịch"
        viewControllers = [
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .all, transactionRepository: ListTransactionRepositoryImp())),
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .earn, transactionRepository: ListTransactionRepositoryImp())),
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .exchange, transactionRepository: ListTransactionRepositoryImp())),
            TransactionHistoryChildViewController.create(with: self.navigator, viewModel: TransactionHistoryChildModel(selectedTab: .used, transactionRepository: ListTransactionRepositoryImp())),
        ];
    }

}

extension TransactionHistoryViewController: PageboyViewControllerDataSource, TMBarDataSource {

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
            title = "Tất cả"
        } else if(index == 1) {
            title = "Tích điểm"
        } else if(index == 2) {
            title = "Đổi điểm"
        } else if(index == 3) {
            title = "Dùng điểm"
        }
        return TMBarItem(title: title)
    }
}

//
//  TopupDataViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/08/2024.
//

import UIKit
import Tabman
import Pageboy
import RxSwift

class TopupDataViewController: TabmanViewController {
    private let disposebag = DisposeBag()
    var navigator: Navigator!
    var viewModel: TopupDataViewModel!
    var tabBar: TMBar!


    class func create(with navigator: Navigator, viewModel: TopupDataViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupDataViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }


    private var viewControllers: [BaseViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initTabView()
        bindToView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        setupTransparentNavigationBar()
    }

    func initView() {
        viewControllers = [
            TopupListViewController.create(
                with: self.navigator,
                viewModel: TopupListViewModel(
                    topupRepository: TopupRepositoryImp(),
                    topupDataType: .topup
                )
            ),
            TopupListViewController.create(
                with: self.navigator,
                viewModel: TopupListViewModel(
                    topupRepository: TopupRepositoryImp(),
                    topupDataType: .buyCard
                )
            ),
        ];
        self.view.backgroundColor = .clear
    }

    func bindToView() {
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
        tabBar = bar
        // Add the bar to the view controller
        addBar(bar, dataSource: self, at: .top)
    }
}


extension TopupDataViewController: PageboyViewControllerDataSource, TMBarDataSource {

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
            title = "Nạp data"
        } else if(index == 1) {
            title = "Đổi mã thẻ"
        }
        return TMBarItem(title: title)
    }
}

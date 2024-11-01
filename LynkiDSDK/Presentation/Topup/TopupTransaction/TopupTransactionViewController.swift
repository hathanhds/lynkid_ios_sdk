//
//  TopupTransactionViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 09/08/2024.
//

import UIKit
import RxSwift
import Tabman
import Pageboy

class TopupTransactionViewController: TabmanViewController {

    var navigator: Navigator!
    var viewModel: TopupTransactionViewModel!
    var gradientView: UIView?
    var gradientImageView: UIImageView?

    class func create(with navigator: Navigator, viewModel: TopupTransactionViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupTransactionViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    private var viewControllers: [BaseViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initTabView()
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        setupTransparentNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func setupNavBar() {
        setupGradientViewBehindBars()
        addBackButton()
        navigationItem.title = "Lịch sử"
    }

    func initView() {
        viewControllers = [
            TopupTransactionListViewController.create(with: self.navigator, viewModel: TopupTransactionListViewModel(topupRepository: TopupRepositoryImp(), topupType: .topupPhone)),
            TopupTransactionListViewController.create(with: self.navigator, viewModel: TopupTransactionListViewModel(topupRepository: TopupRepositoryImp(), topupType: .topupData))
        ]
    }

    func addBackButton(withIcon icon: UIImage? = .iconBack) {
        self.navigationController?.navigationBar.backIndicatorImage = icon
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(performBack))
    }

    @objc func performBack() {
        self.navigationController?.popViewController(animated: true)
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


extension TopupTransactionViewController: PageboyViewControllerDataSource, TMBarDataSource {

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
            title = "Điện thoại"
        } else if(index == 1) {
            title = "Data 3G/4G"
        }
        return TMBarItem(title: title)
    }
}

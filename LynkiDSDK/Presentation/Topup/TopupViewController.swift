//
//  TopupViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 09/08/2024.
//

import UIKit
import Tabman
import Pageboy
import RxSwift

class TopupViewController: UIViewController {
    private let disposebag = DisposeBag()
    var pageViewController: UIPageViewController!
    var navigator: Navigator!
    var viewModel: TopupViewModel!

    class func create(with navigator: Navigator, viewModel: TopupViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    let segmentedControl = UISegmentedControl(items: ["Điện thoại", "Data 3G/4G"])
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initPageView()
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        setupTransparentNavigationBar()
    }

    func initPageView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        let page1 = TopupPhoneViewController.create(with: self.navigator, viewModel: TopupPhoneViewModel())
        let page2 = TopupDataViewController.create(with: self.navigator, viewModel: TopupDataViewModel())

        viewControllers = [page1, page2]

        let displayPage = viewModel.topupType == .topupPhone ? page1 : page2
        pageViewController.setViewControllers([displayPage], direction: .forward, animated: true, completion: nil)

        // Add the PageViewController to the current view
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        // Set constraints for pageViewController
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

    }

    func setupNavBar() {
        setupGradientViewBehindBars()
        addBackButton()
        addRightBarButton()
        initSegment()
    }

    func addBackButton(withIcon icon: UIImage? = .iconBack) {
        self.navigationController?.navigationBar.backIndicatorImage = icon
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(performBack))
    }

    func addRightBarButton(image: UIImage? = .iconTabTransactionInactive) {
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openTopupTransactionScreen))
        self.navigationController?.navigationBar.tintColor = .white
        return
    }

    @objc func openTopupTransactionScreen() {
        self.navigator.show(segue: .topupTransaction) { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func performBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func initSegment() {
        segmentedControl.selectedSegmentIndex = viewModel.topupType == .topupPhone ? 0 : 1
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        segmentedControl.backgroundColor = .white.withAlphaComponent(0.65)
        segmentedControl.tintColor = .c242424
        let textAttributes = [NSAttributedString.Key.font: UIFont.f14r]
        segmentedControl.setTitleTextAttributes(textAttributes as [NSAttributedString.Key: Any], for: .normal)
        segmentedControl.setTitleTextAttributes(textAttributes as [NSAttributedString.Key: Any], for: .selected)
        // Add the segmented control to the navigation bar
        self.navigationItem.titleView = segmentedControl
    }

    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = index > (pageViewController.viewControllers?.first.map { viewControllers.firstIndex(of: $0) ?? 0 } ?? 0) ? .forward : .reverse

        pageViewController.setViewControllers([viewControllers[index]], direction: direction, animated: true, completion: nil)

    }
}

extension TopupViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < (viewControllers.count - 1) else {
            return nil
        }
        return viewControllers[index + 1]
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: currentViewController) {
            segmentedControl.selectedSegmentIndex = index
        }
    }
}

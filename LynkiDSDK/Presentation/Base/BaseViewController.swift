//
//  BaseViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/01/2024.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var navigator: Navigator!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkNetwork()
        self.initView()
        self.setUpData()
        self.bindToView()
        self.bindToViewModel()
        self.setImage()
    }

    func initView() {
    }

    func setUpData() { }

    func bindToView() { }

    func bindToViewModel() { }

    func setImage() {
    }

    func checkNetwork () {
        NotificationCenter.observe(name: .networkIsConnected) { _ in
//            self.hidePopup()
        }

        NotificationCenter.observe(name: .networkIsNotConnected) { _ in
//            self.showPopup()
        }
    }

    @objc func showPopup() {
        navigator.show(segue: .popup(type: .noOption, title: "Mất kết nối mạng", message: "Vui lòng kiểm tra lại", image: .imageMascotError!)) { [weak self] vc in
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.navigationController?.present(vc, animated: true)
        }
    }

    @objc func hidePopup() {
        self.dismissViewController()
    }

    func dismissViewController(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        self.navigationController?.dismiss(animated: flag, completion: completion)
    }

    func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    func addBackButton(withIcon icon: UIImage? = .iconBack, selector: Selector? = #selector(BaseViewController.performBack)) {
        setUpNavbar()
        self.navigationController?.navigationBar.backIndicatorImage = icon
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: selector)
    }

    func setUpNavbar() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.c591C90!.cgColor, UIColor.c971ACC!.cgColor])
    }

    func addDiamondBackButton(withIcon icon: UIImage? = .iconBackYellow, color: UIColor? = .diamondBgColor, selector: Selector? = #selector(BaseViewController.performBack)) {

        self.navigationController?.navigationBar.tintColor = .diamondColor
        self.navigationController?.navigationBar.backIndicatorImage = icon
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
//        self.navigationController?.navigationBar.barTintColor = .diamondBgColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.diamondBgColor!.cgColor, UIColor.diamondBgColor!.cgColor], titleColor: UIColor.diamondColor!)

        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.diamondColor!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: selector)

    }

    @objc func performBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func addRightBarButtonWith(image: UIImage?, title: String? = nil, selector: Selector) {
        self.navigationController?.navigationBar.setGradientBackground(colors: [UIColor.c591C90!.cgColor, UIColor.c971ACC!.cgColor])
        if let image = image {
            self.navigationController?.navigationBar.backIndicatorImage = image
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
            self.navigationController?.navigationBar.tintColor = .white
            return
        }

        if let rightTitle = title {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightTitle, style: .plain, target: self, action: selector)
        }
    }
}

extension BaseViewController {

//    func openLaunchcreen() {
//        self.navigator.show(segue: .launchScreen) { [weak self] vc in
//            guard let self = self else { return }
//            let navController = UINavigationController(rootViewController: vc)
//            navController.modalPresentationStyle = .fullScreen
//            self.present(navController, animated: true)
//        }
//    }

    func openAnonymousLogin() {
        self.navigator.show(segue: .launchScreen) { [weak self] vc in
            guard let self = self else { return }
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }

    func openMainScreen() {
        self.navigator.show(segue: .main) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true) {
                self.showToast(ofType: .success, withMessage: "Đồng bộ tài khoản thành công", afterSeconds: 1.0)
            }
        }
    }

    func openSearchScreen() {
        self.navigator.show(segue: .search) { [weak self] vc in
            guard let self = self else { return }
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }

    func backToHomeScreen() {
        if let tabBarController = self.tabBarController {
            // Access the navigation controller of the first tab (if it exists)
            if let homeNavController = tabBarController.viewControllers?[0] as? UINavigationController {
                // Pop to the root view controller of the home tab's navigation stack
                homeNavController.popToRootViewController(animated: false)
            }
            // Switch to the first tab
            tabBarController.selectedIndex = 0
        } else {
            dismissViewController {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}


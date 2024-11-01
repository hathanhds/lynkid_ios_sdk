//
//  Anonymous.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/03/2024.
//

import Foundation
import UIKit


class AnonymousViewController: BaseViewController {

    typealias ViewModel = AnonymousViewModel
    @IBOutlet weak var loginButton: UIButton!

    static func create(with navigator: Navigator, viewModel: AnonymousViewModel) -> Self {
        let vc = UIStoryboard.anonymous.instantiateViewController(ofType: AnonymousViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: AnonymousViewModel!

    // IBOutlet
    @IBOutlet weak var installAppButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        self.setUpNavbar()
        loginButton.setTitle("Đăng nhập bằng \(AppConfig.shared.merchantName)", for: .normal)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        installAppButton.setCommonGradient()
    }
    
    @IBAction func installAppAction(_ sender: Any) {
        UtilHelper.openLynkiDAPP()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        UtilHelper.openLaunchScreen()
    }
    
    
}

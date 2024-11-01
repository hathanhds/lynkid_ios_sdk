//
//  PopupAnonymousViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 31/07/2024.
//

import Foundation
import UIKit

class PopupLoginViewController: BaseViewController {
    var viewModel: PopupLoginViewModel!

    class func create(with navigator: Navigator, viewModel: PopupLoginViewModel) -> PopupLoginViewController {
        let vc = UIStoryboard.popup.instantiateViewController(ofType: PopupLoginViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }

    // Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var installAppButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (viewModel.isDiamond) {
            installAppButton.setDiamondButtonGradient()
        } else {
            installAppButton.setCommonGradient()
        }

    }

    override func initView() {
        if (viewModel.isDiamond) {
            titleLabel.textColor = .white
            messageLabel.textColor = .white
            loginButton.setTitleColor(.white, for: .normal)
            containerView.backgroundColor = .diamondBgColor
        }
    }

    override func bindToView() {

    }

    // MARK: -Action
    @IBAction func installAppAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        UtilHelper.openLynkiDAPP()
    }

    @IBAction func loginAction(_ sender: Any) {
        UtilHelper.openLaunchScreen()
    }

}

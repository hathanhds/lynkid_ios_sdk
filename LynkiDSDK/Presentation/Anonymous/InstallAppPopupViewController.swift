//
//  InstallAppPopupViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/03/2024.
//

import Foundation
import UIKit

class InstallAppPopupViewController: BaseViewController {

    static func create(with navigator: Navigator, viewModel: InstallAppPopupViewModel) -> Self {
        let vc = UIStoryboard.anonymous.instantiateViewController(ofType: InstallAppPopupViewController.self)
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: InstallAppPopupViewModel!

    // IBOutlets
    @IBOutlet weak var installAppButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var installAppImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        installAppButton.setInstallAppButtonGradient()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setCommonGradient()
    }

    override func setImage() {
//        closeButton.setImage(with: .iconClose)
        if viewModel.isVpbankDiamond {
            installAppImageView.image = .imageIntsallAppDiamond
        } else {
            installAppImageView.image = .imageIntsallAppNormal
        }

        closeButton.isHidden = viewModel.isTabbar
    }


    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func installAppAction(_ sender: Any) {
        UtilHelper.openLynkiDAPP()
    }

}

//
//  AccountNotExistAndConnectedViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import UIKit
import WebKit

// Không tồn tại tài khoản LID với SĐT X từ App chủ
// Tồn tại tài khoản LID với số điện thoại Y
// Số điện thoai Y LID liên kết tài khoản app chủ = SĐT X

class AccountNotExistAndConnectedViewController: BaseViewController, ViewControllerType {
    typealias ViewModel = AccountNotExistAndConnectedViewModel

    static func create(with navigator: Navigator, viewModel: AccountNotExistAndConnectedViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: AccountNotExistAndConnectedViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var checkBoxUserConnectedImageView: UIImageView!
    @IBOutlet weak var avatarUserConnectedImageView: UIImageView!
    @IBOutlet weak var phoneUserConnectedLabel: UILabel!
    @IBOutlet weak var userConnectedContainerView: UIView!

    @IBOutlet weak var checkBoxUserNotConnectedImageView: UIImageView!
    @IBOutlet weak var avatarUserNotConnectedImageView: UIImageView!
    @IBOutlet weak var phoneUserNotConnectedLabel: UILabel!
    @IBOutlet weak var notConnectedUserContainerView: UIView!

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    // Variables
    var viewModel: AccountNotExistAndConnectedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        acceptButton.setCommonGradient()
        view.setCommonGradient()
    }

    override func initView() {
        phoneUserConnectedLabel.text = AppConfig.shared.connectedPhone.maskedString()
        phoneUserNotConnectedLabel.text = AppConfig.shared.phoneNumberFormatter
    }

    override func setImage() {
        checkBoxUserConnectedImageView.image = .iconAuthCheckBox
        checkBoxUserNotConnectedImageView.image = .iconAuthCheckBox
        avatarUserConnectedImageView.image = .imgAvatarDefault
        avatarUserNotConnectedImageView.image = .imgAvatarDefault
//        closeButton.setImage(with: .iconClose)
    }

    override func bindToView() {
        viewModel.output.selectedType.subscribe(onNext: { [weak self] selectedType in
            guard let self = self else { return }
            if (selectedType == .connected) {
                selectedUI(containerView: userConnectedContainerView,
                    checkBoxImage: checkBoxUserConnectedImageView,
                    phoneNumberLabel: phoneUserConnectedLabel)
                notSelectedUI(containerView: notConnectedUserContainerView,
                    checkBoxImage: checkBoxUserNotConnectedImageView,
                    phoneNumberLabel: phoneUserNotConnectedLabel)
            } else {
                selectedUI(containerView: notConnectedUserContainerView,
                    checkBoxImage: checkBoxUserNotConnectedImageView,
                    phoneNumberLabel: phoneUserNotConnectedLabel)
                notSelectedUI(containerView: userConnectedContainerView,
                    checkBoxImage: checkBoxUserConnectedImageView,
                    phoneNumberLabel: phoneUserConnectedLabel)
            }
        }).disposed(by: self.disposeBag)

        viewModel.output.createMemberResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(()):
                AppConfig.shared.viewMode = .authenticated
                self.navigator.show(segue: .main) { [weak self] vc in
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: {
                        self?.showToast(ofType: .success, withMessage: "Tạo tài khoản thành công")
                    })
                }
            case .failure(let error):
                UtilHelper.showAPIErrorPopUp(parentVC: self, message: error.message)
            }
        }).disposed(by: self.disposeBag)

        viewModel.output.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }).disposed(by: self.disposeBag)
    }

    @IBAction func onSelectConnectedUserAction(_ sender: Any) {
        viewModel.input.onSelectPhone.onNext(.connected)
    }

    @IBAction func onSelectedNotConnectedUserAction(_ sender: Any) {
        viewModel.input.onSelectPhone.onNext(.notConnected)
    }

    @IBAction func acceptAction(_ sender: Any) {
        let type = viewModel.output.selectedType.value
        if (type == .connected) {
            self.navigator.show(segue: .authenConnectedPhoneNumber) { [weak self] vc in
                guard let self = self else { return }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        } else {
            viewModel.createMember()
        }
    }

    @IBAction func skipAction(_ sender: Any) {
        AppConfig.shared.viewMode = .anonymous
        self.navigator.show(segue: .main) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dimissAllViewControllers()
    }

    func selectedUI(containerView: UIView, checkBoxImage: UIImageView, phoneNumberLabel: UILabel) {
        containerView.borderWidth = 1
        containerView.borderColor = .mainColor
        containerView.backgroundColor = .cEFE7F6
        checkBoxImage.isHidden = false
        phoneNumberLabel.textColor = .mainColor
    }

    func notSelectedUI(containerView: UIView, checkBoxImage: UIImageView, phoneNumberLabel: UILabel) {
        containerView.borderWidth = 1
        containerView.borderColor = .cD8D6DD
        containerView.backgroundColor = .white
        checkBoxImage.isHidden = true
        phoneNumberLabel.textColor = .c242424
    }
}




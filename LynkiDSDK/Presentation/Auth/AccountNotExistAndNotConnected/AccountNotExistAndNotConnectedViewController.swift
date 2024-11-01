//
//  AccountNotExistAndNotConnectedViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import UIKit
import RxSwift

// Không tồn tại tài khoản LID với SĐT X từ App chủ
// SĐT X không có liên kết LID

class AccountNotExistAndNotConnectedViewController: BaseViewController, ViewControllerType {
    typealias ViewModel = AccountNotExistAndNotConnectedViewModel

    static func create(with navigator: Navigator, viewModel: AccountNotExistAndNotConnectedViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: AccountNotExistAndNotConnectedViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlet
    @IBOutlet weak var closeButton: UIButton!

    var viewModel: AccountNotExistAndNotConnectedViewModel!

    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setImage() {
//        closeButton.setImage(with: .iconClose)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.setCommonGradient()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func bindToView() {
        viewModel.output.createMemberResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(()):
                AppConfig.shared.viewMode = .authenticated
                self.navigator.show(segue: .main) { [weak self] vc in
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: {
                        self?.showToast(ofType: .success, withMessage: "Đăng nhập thành công")
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

    @IBAction func closeAction(_ sender: Any) {
        self.dimissAllViewControllers()
    }

    @IBAction func skipAction(_ sender: Any) {
        self.navigator.show(segue: .main) { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
    }

    @IBAction func continueAction(_ sender: Any) {
        viewModel.input.onAccept.onNext(())
    }

}


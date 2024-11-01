//
//  AuthenConnectedPhoneNumberViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import UIKit
import RxSwift

// Tồn tại tài khoản X từ App chủ
// SĐT X đã liên kết LID

class AuthenConnectedPhoneNumberViewController: BaseViewController, ViewControllerType {
    typealias ViewModel = AuthenConnectedPhoneNumberViewModel

    static func create(with navigator: Navigator, viewModel: AuthenConnectedPhoneNumberViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: AuthenConnectedPhoneNumberViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    var viewModel: AuthenConnectedPhoneNumberViewModel!

    // Outlets

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private let bottomButton: CGFloat = 34.0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.setCommonGradient()
        phoneNumberLabel.text = AppConfig.shared.connectedPhone.maskedString()
    }

    override func initView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.cancelAction))
        bgView.addGestureRecognizer(gesture)
        // Auto focus
        phoneNumberTF.becomeFirstResponder()
        // Register keyboard notifications
        NotificationCenter.observe(name: UIResponder.keyboardWillShowNotification) { [weak self] notification in
            self?.keyboardWillShow(notification: notification)
        }
        NotificationCenter.observe(name: UIResponder.keyboardWillHideNotification) { [weak self] notification in
            self?.keyboardWillHide(notification: notification)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    override func bindToView() {
        self.phoneNumberTF.rx.text
            .subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if let text = text, !text.isEmpty {
                self.continueButton.enable()
            } else {
                self.continueButton.disable()
            }
        })
            .disposed(by: self.disposeBag)


        self.phoneNumberTF.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.phoneNumberTF.text = self.phoneNumberTF.text?.phoneNumberFormatter()
        })
            .disposed(by: self.disposeBag)

        viewModel.output.authenConnectedPhoneResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(()):
                AppConfig.shared.viewMode = .authenticated
                self.navigator.show(segue: .main) { [weak self] vc in
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: {
                        self?.showToast(ofType: .success, withMessage: "Đồng bộ tài khoản thành công")
                    })
                }
            case .failure(_):
                UtilHelper.showAPIErrorPopUp(parentVC: self)
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.size.height
        bottomConstraint.constant = self.view.frame.origin.y + keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint.constant = bottomButton
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func continueAction(_ sender: Any) {
        viewModel.input.onContinue.onNext(self.phoneNumberTF.text)
    }
}

extension AuthenConnectedPhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newLength = 0
        if let text = textField.text,
            let rangeOfTextToReplace = Swift.Range(range, in: text) {
            let substringToReplace = text[rangeOfTextToReplace]
            newLength = text.count - substringToReplace.count + string.count
        }
        return newLength < 13
            && !string.containsAlphabetLetters()
            && !string.containsSpecialCharacters()
    }
}



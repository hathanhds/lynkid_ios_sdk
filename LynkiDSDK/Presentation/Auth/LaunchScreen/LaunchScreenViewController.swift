//
//  LauncScreenViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/03/2024.
//

import Foundation
import RxSwift
import UIKit
import SwiftyAttributes

class LaunchScreenViewController: BaseViewController {

    static func create(with navigator: Navigator, viewModel: LaunchScreenViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: LaunchScreenViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets


    var viewModel: LaunchScreenViewModel!
    @IBOutlet weak var logoMerchantImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.acceptButton.setCommonGradient()
        self.view.setCommonGradient()
    }

    override func initView() {
        userNameLabel.text = AppConfig.shared.userName
        phoneNumberLabel.text = AppConfig.shared.phoneNumberFormatter
        setUpTermsAndPolicyText()
    }

    override func setImage() {
//        closeButton.setImage(with: .iconClose)
        logoImageView.image = .iconAppPlaceholder
        avatarImageView.image = .imgAvatarDefault
        logoMerchantImageView.image = .imageMerchantDefault
    }

    func setUpTermsAndPolicyText() {
        let fontRegular: UIFont = .f12r!
        let fontSemiBold: UIFont = .f12s!

        let attribute1 = "Bằng việc nhấn ".withAttributes([
                .textColor(.c6D6B7A!),
                .font(fontRegular)
            ])
        let attribute2 = "\"Cho phép\" ".withAttributes([
                .textColor(.c242424!),
                .font(fontSemiBold),
            ])
        let attribute3 = ", tôi đã đọc và đồng ý với ".withAttributes([
                .textColor(.c6D6B7A!),
                .font(fontRegular)
            ])
        let attribute4 = "Điều khoản & Điều kiện".withAttributes([
                .textColor(.mainColor!),
                .font(fontSemiBold),
                .underlineStyle(.single)

            ])
        let attribute5 = " và ".withAttributes([
                .textColor(.c6D6B7A!),
                .font(fontRegular)
            ])
        let attribute6 = "Chính sách bảo vệ dữ liệu cá nhân".withAttributes([
                .textColor(.mainColor!),
                .font(fontSemiBold),
                .underlineStyle(.single)
            ])
        let attribute7 = " của LynkiD ".withAttributes([
                .textColor(.c6D6B7A!),
                .font(fontRegular)
            ])

        policyLabel.attributedText = attribute1 + attribute2 + attribute3 + attribute4 + attribute5 + attribute6 + attribute7
        policyLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        policyLabel.addGestureRecognizer(tapGesture)
    }

    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = policyLabel.text else { return }
        let terms = (text as NSString).range(of: "Điều khoản & Điều kiện")
        let policy = (text as NSString).range(of: "Chính sách bảo vệ dữ liệu cá nhân")
        if gesture.didTapAttributedTextInLabel(label: self.policyLabel, inRange: terms) {
            self.navigator.show(segue: .termsAndPolivy(type: .terms)) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if gesture.didTapAttributedTextInLabel(label: self.policyLabel, inRange: policy) {
            self.navigator.show(segue: .termsAndPolivy(type: .policy)) { [weak self] vc in
                guard let self = self else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    override func bindToView() {
        viewModel.output.isLoading.subscribe { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }.disposed(by: self.disposeBag)

        // check show error
        viewModel.output.isShowError.subscribe { [weak self] isShowError in
            guard let self = self else { return }
            if (isShowError) {
                UtilHelper.showAPIErrorPopUp(parentVC: self)
            }
        }.disposed(by: self.disposeBag)

        // check next screen type
        viewModel.output.nextScreenType.subscribe { [weak self] screenType in
            guard let self = self else { return }
            switch screenType {
            case .existAndConnected:
                self.navigator.show(segue: .accountExistAndConnected) { [weak self] vc in
                    guard let self = self else { return }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            case .existAndNotConnected:
                self.navigator.show(segue: .accountExistAndNotConnected) { [weak self] vc in
                    guard let self = self else { return }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            case .notExistAndConnected:
                self.navigator.show(segue: .accountNotExistAndConnected) { [weak self] vc in
                    guard let self = self else { return }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            case .notExistAndNotConnected:
                self.navigator.show(segue: .accountNotExistAndNotConnected) { [weak self] vc in
                    guard let self = self else { return }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            default:
                // do nothing
                break
            }
        }.disposed(by: self.disposeBag)
    }

    // MARK: - Action

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func denyAction(_ sender: Any) {
        AppConfig.shared.viewMode = .anonymous
        self.navigator.show(segue: .main) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }

    }

    @IBAction func acceptAction(_ sender: Any) {
        viewModel.generatePartnerToken();
    }

}

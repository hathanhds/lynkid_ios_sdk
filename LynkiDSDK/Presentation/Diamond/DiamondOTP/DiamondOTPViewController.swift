//
//  OTPViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/06/2024.
//

import Foundation
import UIKit
import SwiftyAttributes

class DiamondOTPViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: DiamondOTPViewModel) -> Self {
        let vc = UIStoryboard.diamond.instantiateViewController(ofType: DiamondOTPViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var otpView: OTPStackView!
    @IBOutlet weak var resendButton: UIButton!

    // Variables
    var viewModel: DiamondOTPViewModel!
    var timer: Timer?
    var totalTime: Int = 179 // seconds

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confirmButton.setDiamondButtonGradient()
        view.setDiamondBackgroundGradient()
    }

    override func initView() {
        addDiamondBackButton()
        setUpTitle()
        setUpOtpView()
    }


    func setUpTitle() {
        self.title = "Xác thực"
        let attribute1 = "Vui lòng nhập mã xác thực (OTP) được gửi về số điện thoại ".withAttributes([
                .textColor(.white),
                .font(.f14r ?? .systemFont(ofSize: 14.0))
            ])
        let attribute2 = " \(viewModel.phoneNumber)".withAttributes([
                .textColor(.white),
                .font(.f14s ?? .systemFont(ofSize: 14.0, weight: .bold))
            ])
        titleLabel.attributedText = attribute1 + attribute2
    }

    func setUpOtpView() {
        otpView.delegate = self
        otpView.isDiamond = true
        otpView.backgroundColor = .clear
        startOtpTimer()
    }

    private func startOtpTimer() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }

    private func resetTimer() {
        stopTimmer()
        startOtpTimer()
    }

    private func stopTimmer() {
        timer?.invalidate()
        timer = nil
        totalTime = 179
    }

    @objc func updateTimer() {
        self.countDownLabel.text = "Hết hạn trong (\(timeFormatted(totalTime)))" // will show timer
        if totalTime != 0 {
            totalTime -= 1 // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    override func bindToView() {
        viewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                showDiamondLoading()
            } else {
                hideLoading()
            }
        }).disposed(by: disposeBag)

        viewModel.errorText.subscribe(onNext: { [weak self] errorText in
            guard let self = self else { return }
            errorLabel.text = errorText
            errorLabel.isHidden = errorText.isEmpty
            otpView.showsWarningColor = !errorText.isEmpty
        }).disposed(by: disposeBag)

        viewModel.confirmResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transaction):
                self.navigator.show(segue: .diamondExchangeSuccess(
                    giftInfo: viewModel.giftInfo,
                    transactionInfo: transaction,
                    quantity: viewModel.quantity)) { [weak self] vc in
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                if (error.code == "PhoneNumberBlocked" || error.code == "PhoneNumberReachMaxFailure") {
                    self.navigator.show(segue: .popup(type: .twoOption,
                        title: "Tài khoản bị khoá",
                        message: "Tài khoản của bạn tạm thời bị khóa do thao tác quá nhiều lần. Vui lòng thử lại sau hoặc liên hệ LynkiD để được hỗ trợ nhé.",
                        image: .imageMascotOTP!,
                        confirmnButton: (title: "Trợ giúp", action: {
                            UtilHelper.callLynkiDHotLine()
                        }),
                        cancelButton: (title: "Bỏ qua", action: nil)
                        )
                    ) { [weak self] vc in
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self?.navigationController?.present(vc, animated: true)
                    }
                }
            }
        }).disposed(by: disposeBag)

        viewModel.resendResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                resetTimer()
            case .failure(let error):
                UtilHelper.showAPIErrorPopUp(
                    parentVC: self,
                    message: error.message ?? "",
                    isDiamond: true)
            }
        }).disposed(by: disposeBag)

        confirmButton.rx
            .tap
            .subscribe { [weak self] _ in
            guard let self = self else { return }
            let fillText = otpView.textFieldsCollection.map { $0.text ?? "" }.joined(separator: "")
            viewModel.confirmOtpCreateTransaction(otpCode: fillText)
        }.disposed(by: disposeBag)

        resendButton.rx
            .tap
            .subscribe { [weak self] _ in
            guard let self = self else { return }
            viewModel.resendOtp()
        }.disposed(by: disposeBag)
    }
}

extension DiamondOTPViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        if (isValid) {
            confirmButton.enable()
        } else {
            confirmButton.disable()
        }
        errorLabel.isHidden = true
    }
}

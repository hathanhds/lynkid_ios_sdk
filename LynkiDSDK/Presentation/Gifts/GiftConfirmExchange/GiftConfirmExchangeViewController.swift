//
//  GiftConfirmExchangeViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 31/05/2024.
//

import UIKit
import RxSwift

class GiftConfirmExchangeViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: GiftConfirmExchangeViewModel) -> Self {
        let vc = UIStoryboard.giftExchange.instantiateViewController(ofType: GiftConfirmExchangeViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets:
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var requiredCoinLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var userCointLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!

    // Thông tin nhận hàng
    @IBOutlet weak var shipInfoContainerView: UIView!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var receiverPhoneLabel: UILabel!
    @IBOutlet weak var receiverLocationLabel: UILabel!
    @IBOutlet weak var noteContainerView: UIStackView!
    @IBOutlet weak var noteLabel: UILabel!
    // Thông tin khác

    @IBOutlet weak var giftInfoContainer: UIView!
    @IBOutlet weak var otherInfoContainerView: UIView!
    @IBOutlet weak var exchangeDateLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!


    // Variables
    var viewModel: GiftConfirmExchangeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confirmButton.setCommonGradient()
    }

    override func initView() {
        self.title = "Xác nhận"
        self.addBackButton()
        setUpGiftItem()
        if #available(iOS 15, *) {
            exchangeDateLabel.text = Date.now.toString(formatter: .ddMMyyyy)
        } else {
            exchangeDateLabel.text = Date().toString(formatter: .ddMMyyyy)
        }
    }

    func setUpGiftItem() {
        let giftInfo = viewModel.giftInfo
        let imageLink = giftInfo.imageLink?.first?.fullLink
        giftImageView.setSDImage(with: imageLink)
        giftNameLabel.text = giftInfo.giftInfor?.name
        userCointLabel.text = AppUserDefaults.userPoint.formatter()
        requiredCoinLabel.text = viewModel.giftExchangePrice.formatter()


        giftInfoContainer.layer.masksToBounds = true
        giftInfoContainer.layer.cornerRadius = 12
        giftInfoContainer.layer.borderWidth = 1
        giftInfoContainer.layer.borderColor = UIColor.cEFEFF6?.cgColor
    }

    override func bindToView() {

        if let receiverInfo = viewModel.receiverInfo {
            shipInfoContainerView.isHidden = false
            otherInfoContainerView.isHidden = false
            receiverNameLabel.text = receiverInfo.name
            receiverPhoneLabel.text = receiverInfo.phoneNumber
            receiverLocationLabel.text = receiverInfo.getFullAddress()
            noteLabel.text = receiverInfo.note
            noteContainerView.isHidden = (receiverInfo.note ?? "").isEmpty
        } else {
            shipInfoContainerView.isHidden = true
            otherInfoContainerView.isHidden = true
        }

        viewModel.output.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }).disposed(by: disposeBag)

        viewModel.output.quantity.subscribe(onNext: { [weak self] quantity in
            guard let self = self else { return }
            quantityLabel.text = "\(quantity)"
            let totalPrice = Double(quantity) * viewModel.giftExchangePrice
            totalPriceLabel.text = totalPrice.formatter()
        }).disposed(by: disposeBag)

        // Create transaction result
        viewModel.output.createTransactionResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                // Nếu số tiền lớn hơn 2 triệu -> isOtpSent = true
                // Navigate màn otp
                let isOtpSent = res?.isOtpSent ?? false
                if (isOtpSent) {
                    // navigate to OTP screen
                    self.navigator.show(segue: .otp(data: OTPArguments(giftsRepository: GiftsRepositoryImpl(), sessionId: viewModel.sessionId,
                        quantity: viewModel.output.quantity.value,
                        giftInfo: viewModel.giftInfo))) { [weak self] vc in
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }

                } else {
                    self.navigator.show(segue: .giftExchangeSuccess(giftInfo: viewModel.giftInfo,
                        transactionInfo: res?.items?.first ?? CreateTransactionItem(),
                        quantity: viewModel.output.quantity.value
                        )) { [weak self] vc in
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                break
            case .failure(let res):
                UtilHelper.showAPIErrorPopUp(
                    parentVC: self,
                    message: res.message ?? "")
                break
            }
        }).disposed(by: disposeBag)
    }
    // MARK: Action
    @IBAction func onMinusAction(_ sender: Any) {
        viewModel.onMinus()
    }

    @IBAction func onPlusAction(_ sender: Any) {
        viewModel.onPlus(vc: self)
    }

    @IBAction func editInfoShippingAction(_ sender: Any) {
        self.navigator.show(segue: .physicalShipping(
            giftInfo: viewModel.giftInfo,
            giftExchangePrice: viewModel.giftExchangePrice,
            receiverInfoModel: viewModel.receiverInfo
            )) { [weak self] vc in
            guard let self = self else { return }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func confirmAction(_ sender: Any) {
        viewModel.onCreateTransaction()
    }

}


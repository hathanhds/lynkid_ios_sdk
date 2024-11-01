//
//  TopupConfirmViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/08/2024.
//

import UIKit
import EasyTipView

class TopupConfirmViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: TopupConfirmViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupConfirmViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var giftInfoContainerView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var requiredCoinLabel: UILabel!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var quantityLabel: UILabel!

    @IBOutlet weak var userPointLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var serviceContainerStackView: UIStackView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var topupPhoneContainerStackView: UIStackView!
    @IBOutlet weak var topupPhoneNumberLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var cardPriceContainerStackView: UIStackView!
    @IBOutlet weak var cardPriceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeContainerStackView: UIStackView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var durationContainerStackView: UIStackView!


    // Variables
    var viewModel: TopupConfirmViewModel!
    var tipView = EasyTipView(text: "")
    var counter = 0
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.title = "Xác nhận"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()

    }

    override func initView() {
        setUpEasyView(tipView: &tipView)
        setupConfirmInfo()
    }

    func setupConfirmInfo() {
        let data = viewModel.data
        let brandInfo = data.brandInfo
        let giftInfor = data.giftInfo.giftInfor
        brandImageView.setSDImage(with: brandInfo.linkLogo, scaleMode: .scaleAspectFit)
        giftNameLabel.text = giftInfor?.name
        requiredCoinLabel.text = (giftInfor?.requiredCoin ?? 0).formatter()
        let topupPhoneType = data.topupPhoneType
        let topupDataType = data.topupDataType
        if (topupPhoneType == .buyCard || topupDataType == .buyCard) {
            quantityStackView.isHidden = false
            topupPhoneContainerStackView.isHidden = true
        } else {
            quantityStackView.isHidden = true
            topupPhoneContainerStackView.isHidden = false
            topupPhoneNumberLabel.text = "\(data.contactName): \(data.phoneNumber)"
        }
        userPointLabel.text = AppUserDefaults.userPoint.formatter()
        if (data.topupType == .topupPhone) {
            serviceNameLabel.text = topupPhoneType?.rawValue
            cardPriceLabel.text = "\((giftInfor?.fullPrice ?? 0).formatter())đ"
            cardPriceContainerStackView.isHidden = false
            sizeContainerStackView.isHidden = true
            durationContainerStackView.isHidden = true
        } else {
            serviceNameLabel.text = topupDataType?.rawValue
            sizeLabel.text = giftInfor?.name
            cardPriceContainerStackView.isHidden = true
            sizeContainerStackView.isHidden = false
            durationLabel.text = giftInfor?.description?.split(separator: ":").last as? String
            durationContainerStackView.isHidden = false
        }
        brandNameLabel.text = brandInfo.brandName
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        confirmButton.setCommonGradient()
    }

    override func bindToView() {
        // Loading
        viewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }).disposed(by: disposeBag)

        // Quantity
        viewModel.quantity.subscribe(onNext: { [weak self] quantity in
            guard let self = self else { return }
            quantityLabel.text = "\(quantity)"
            let requiredCoin = viewModel.data.giftInfo.giftInfor?.requiredCoin ?? 0
            let totalPrice = Double(quantity) * requiredCoin
            totalAmountLabel.text = totalPrice.formatter()
        }).disposed(by: disposeBag)

        // Create transaction result
        viewModel.createTransactionResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                // Nếu số tiền lớn hơn 2 triệu -> isOtpSent = true
                // Navigate màn otp
                let isOtpSent = res?.isOtpSent ?? false
                if (isOtpSent) {
                    self.navigator.show(segue: .otp(data: OTPArguments(giftsRepository: GiftsRepositoryImpl(), sessionId: viewModel.sessionId,
                        quantity: viewModel.quantity.value,
                        giftInfo: viewModel.data.giftInfo,
                        titleExchangeSuccess: viewModel.getTitleExchange(),
                        topupPhoneType: viewModel.data.topupPhoneType,
                        topupDataType: viewModel.data.topupDataType
                        ))) { [weak self] vc in
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    self.navigator.show(segue: .topupSuccess(data: TopupSuccessArgument(
                        giftInfo: viewModel.data.giftInfo,
                        transactionInfo: res?.items?.first ?? CreateTransactionItem(),
                        quantity: viewModel.quantity.value,
                        title: viewModel.getTitleExchange(),
                        topupPhoneType: viewModel.data.topupPhoneType,
                        topupDataType: viewModel.data.topupDataType
                        )
                        )) { [weak self] vc in
                        guard let self = self else { return }
                        self.navigationController?.pushViewController(vc, animated: true)
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

    // MARK: -Action
    @IBAction func onPlusAction(_ sender: Any) {
        viewModel.onPlus(vc: self)
    }

    @IBAction func onMinusAction(_ sender: Any) {
        viewModel.onMinus()
    }

    @IBAction func confirmAction(_ sender: Any) {
        viewModel.onCreateTransaction()
    }

    @IBAction func toolTipAction(_ sender: Any) {
        if let tipView = self.view.subviews.first(where: { $0 is EasyTipView }) as? EasyTipView {
            tipView.dismiss()
        } else {
            startTimmer()
            tipView.show(forView: self.durationButton, withinSuperview: self.view)
        }
    }
}

extension TopupConfirmViewController {

    func startTimmer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timmerAction), userInfo: nil, repeats: true)
    }

    func stopTimmer() {
        counter = 0
        tipView.dismiss()
        timer.invalidate()
    }

    @objc func timmerAction() {
        if (counter > 3) {
            stopTimmer()
            return
        }
        counter += 1
    }
}

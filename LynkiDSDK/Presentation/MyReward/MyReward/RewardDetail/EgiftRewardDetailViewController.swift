//
//  RewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import WebKit
import EasyTipView
import SwiftyAttributes

class EgiftRewardDetailViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: EgiftRewardDetailViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: EgiftRewardDetailViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    @IBOutlet weak var _ticketView: UIView!
    @IBOutlet weak var stackContainerView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgHeaderImageView: UIImageView!
    @IBOutlet weak var installAppView: InstallAppBannerSmallView!

    @IBOutlet weak var egiftCodeContainerView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!

    // Redeem Egift View
    @IBOutlet weak var redeemStackView: UIStackView!
    @IBOutlet weak var redeemCodeLabel: UILabel!
    @IBOutlet weak var redeemSerialLabel: UILabel!
    @IBOutlet weak var memberNameFromLabel: UILabel!
    @IBOutlet weak var sendGiftButton: UIButton!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var redeemSerialStackView: UIStackView!

    // Used Egift
    @IBOutlet weak var usedStackView: UIStackView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var usedCodeLabel: UILabel!
    @IBOutlet weak var effectiveDateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var usedSerialLabel: UILabel!
    @IBOutlet weak var qrCodeContainerView: UIView!
    @IBOutlet weak var usedCodeContainerView: UIView!
    @IBOutlet weak var usedSerialContainerView: UIView!
    @IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var usedLineView: UIView!
    @IBOutlet weak var sendAutoUpdateStatusGiftButton: UIButton!
    @IBOutlet weak var barCodeContainerView: UIView!
    @IBOutlet weak var barCodeImageView: UIImageView!


    // Redeem Topup View
    @IBOutlet weak var redeemTopupStackView: UIStackView!
    @IBOutlet weak var redeemTopupCodeLabel: UILabel!
    @IBOutlet weak var redeemSeriTopupLabel: UILabel!
    @IBOutlet weak var redeemTopupButtonStackView: UIStackView!
    @IBOutlet weak var redeemTopupCodeContainerView: UIView!
    @IBOutlet weak var leftTopupButton: UIButton!
    @IBOutlet weak var rightTopupButton: UIButton!


    // Used Topup View
    @IBOutlet weak var usedTopupStackView: UIStackView!
    @IBOutlet weak var usedTopupCodeLabel: UILabel!
    @IBOutlet weak var usedSeriTopupLabel: UILabel!
    @IBOutlet weak var topupPhoneNumberLabel: UILabel!
    @IBOutlet weak var reorderTopupButton: UIButton!
    @IBOutlet weak var usedTopupCodeContainerView: UIView!


    // Header info
    @IBOutlet weak var presentTitleView: UIView!
    @IBOutlet weak var expiredDateInfoButton: UIButton!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var expiredDateLabel: UILabel!
    // Mô tả chung
    @IBOutlet weak var giftInfoContainerView: UIView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var descriptionWebViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionWebView: WKWebView!

    //Hướng dẫn
    @IBOutlet weak var instructionContainerView: UIStackView!
    @IBOutlet weak var instructionWebView: WKWebView!
    @IBOutlet weak var instructionWebViewHeightConstraint: NSLayoutConstraint!

    // Liên hệ
    @IBOutlet weak var contactContainerView: UIStackView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var hotlineContainerView: UIView!
    @IBOutlet weak var hotlineButton: UIButton!
    // Điều kiện sử dụng
    @IBOutlet weak var conditionContainerView: UIView!
    @IBOutlet weak var conditionWebView: WKWebView!
    @IBOutlet weak var conditionWebViewHeightConstraint: NSLayoutConstraint!

    // Địa điểm áp dụng
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var loadMoreLocationButton: UIButton!
    @IBOutlet weak var locationTableViewHeightConstraint: NSLayoutConstraint!

    var viewModel: EgiftRewardDetailViewModel!

    private var isInjectedDescriptionWebView: Bool = false
    private var isInjectedInstructionWebView: Bool = false
    private var isInjectedConditionWebView: Bool = false

    var tipView = EasyTipView(text: "")
    var counter = 0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
        locationTableView.addObserver(self, forKeyPath: "contentSize",
            options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
        locationTableView.removeObserver(self, forKeyPath: "contentSize")
    }

    override func setImage() {
        bgHeaderImageView.image = .bgHeader
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard
        keyPath == "contentSize",
            let newValue = change?[.newKey] as? CGSize,
            let object = object
            else {
            return
        }
        if object is UITableView {
            let height = newValue.height
            self.locationTableViewHeightConstraint.constant = height
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            _ticketView.drawTicket(
                directionHorizontal: false,
                withCutoutRadius: 10,
                andCornerRadius: 12,
                fillColor: UIColor.white,
                andFrame: CGRect(x: 0, y: 0, width: _ticketView.frame.size.width, height: _ticketView.frame.size.height),
                andTicketPosition: CGPoint(x: _ticketView.frame.size.width, y: viewModel.caculateTicketPosition()))
        }

        useButton.setCommonGradient()
        headerView.setCommonGradient()

        // Label quà tặng
        presentTitleView.layer.masksToBounds = true
        presentTitleView.layer.cornerRadius = 12
        presentTitleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        presentTitleView.setCommonGradient()
        installAppView.configureUI()
        reorderButton.setCommonGradient()
        rightTopupButton.setCommonGradient()
        reorderTopupButton.setCommonGradient()
    }

    override func initView() {
        descriptionWebView.navigationDelegate = self
        instructionWebView.navigationDelegate = self
        conditionWebView.navigationDelegate = self
        brandImageView.image = .iconLogoDefault
        locationTableView.register(cellType: GiftLocationTableViewCell.self)
        self.setUpEasyView(tipView: &tipView)
    }

    override func bindToView() {
        viewModel.output.isLoading.subscribe { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.stackContainerView.isHidden = true
                self.showLoading()
            } else {
                self.stackContainerView.isHidden = false
                self.hideLoading()
            }
        }.disposed(by: disposeBag)

        // Reward info
        viewModel.output.giftInfo.subscribe(onNext: { [weak self] giftInfo in
            guard let self = self else { return }
            // Ảnh quà
            let brandImage = giftInfo?.brandInfo?.brandImage
            brandImageView.setSDImage(with: brandImage, placeholderImage: .iconLogoDefault)
            if let giftTransaction = giftInfo?.giftTransaction {
                self.scrollView.isHidden = false
                setUpEGiftCodeView(giftInfo: giftInfo)
                // Header info
                giftNameLabel.text = giftTransaction.giftName
                let dateInfo = viewModel.displaydDateInfo(giftInfo: giftInfo)
                expiredDateLabel.text = dateInfo.title
                expiredDateLabel.textColor = dateInfo.color
                presentTitleView.isHidden = giftTransaction.whyHaveIt != WhyHaveRewardType.received.rawValue

                // Thông tin chung
                setUpGeneralInfo(giftTransaction)

                // Địa điểm áp dụng
                if let giftUsageAddress = giftInfo?.giftUsageAddress, giftUsageAddress.count > 0 {
                    locationContainerView.isHidden = false
                    loadMoreLocationButton.isHidden = giftUsageAddress.count < 3
                } else {
                    loadMoreLocationButton.isHidden = true
                    locationContainerView.isHidden = true
                }
                locationTableView.reloadData()
            } else {
                self.scrollView.isHidden = true
            }
        }).disposed(by: disposeBag)

        // Update gift status
        viewModel.output.updateGiftStatusResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // Do nothing
                break
            case .failure(let res):
                UtilHelper.showAPIErrorPopUp(parentVC: self,
                    message: res.message ?? "")
            }
        }).disposed(by: disposeBag)

        // load giftDetail result
        viewModel.output.loadGiftDetailResult.subscribe (onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let giftInfo):
                if giftInfo.giftCategoryTypeCode == "Diamond" {
                    UtilHelper.openGiftDetailScreen(from: self, giftInfo: giftInfo, giftId: "", isDiamond: true)
                } else {
                    UtilHelper.openGiftDetailScreen(from: self, giftInfo: giftInfo, giftId: "")
                }
                break
            case .failure: break
                // do nothing
            }
        })
            .disposed(by: disposeBag)
    }

// MARK: -Actions
    @IBAction func onBackPressed(_ sender: Any) {
        self.pop()
    }

    @IBAction func sendGiftAction(_ sender: Any) {
        UtilHelper.showInstallAppPopup(parentVC: self)
    }

    @IBAction func useGiftAction(_ sender: Any) {
        navigator.show(segue: .markUsed(didFinish: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.viewModel.updateEgiftStatus()
            }
        })) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
    }

    @IBAction func openEmailAction(_ sender: Any) {
        if let email = viewModel.output.giftInfo.value?.giftTransaction?.contactEmail {
            UtilHelper.openEmail(email: email)
        }
    }

    @IBAction func callHotlineAction(_ sender: Any) {
        if let phone = viewModel.output.giftInfo.value?.giftTransaction?.contactHotline {
            UtilHelper.openPhoneCall(number: phone)
        }
    }

    @IBAction func seeMoreLocationAction(_ sender: Any) {
        self.navigator.show(segue: .giftLocation(giftCode: viewModel.output.giftInfo.value?.giftTransaction?.giftCode ?? "")) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func showInfoExpiredDateAction(_ sender: Any) {
        if let tipView = self.view.subviews.first(where: { $0 is EasyTipView }) as? EasyTipView {
            tipView.dismiss()
        } else {
            startTimmer()
            tipView.show(forView: self.expiredDateInfoButton, withinSuperview: self.view)
        }
    }

    @IBAction func copyGiftCodeAction(_ sender: Any) {
        let code = viewModel.output.giftInfo.value?.eGift?.code ?? ""
        UtilHelper.copyToClipboard(text: code) {
            self.showToast(ofType: .success, withMessage: "Sao chép thành công")
        }
    }

    @IBAction func copySerialAction(_ sender: Any) {
        let code = viewModel.output.giftInfo.value?.giftTransaction?.serialNo ?? ""
        UtilHelper.copyToClipboard(text: code) {
            self.showToast(ofType: .success, withMessage: "Sao chép thành công")
        }
    }

    @IBAction func reorderAction(_ sender: Any) {
        let giftId = "\(viewModel.output.giftInfo.value?.giftTransaction?.giftId ?? 0)"
        viewModel.getGiftDetail(giftId: giftId)
    }


    @IBAction func copyTopupCodeAction(_ sender: Any) {
        copyCodeAndSeriTopup()
    }

    @IBAction func reorderTopupAction(_ sender: Any) {
        self.onReorderTopupAction()
    }
}


// Hiển thị thông tin Egift
extension EgiftRewardDetailViewController {
    func setUpEGiftCodeView(giftInfo: GiftInfoItem?) {
        guard let usedStatus = giftInfo?.eGift?.usedStatus,
            let whyHaveItType = giftInfo?.giftTransaction?.whyHaveItType else {
            return
        }
        let isTopupPhone = giftInfo?.vendorInfo?.type == "TopupPhone"
        if (isTopupPhone) {
            // Hide eGift
            redeemStackView.isHidden = true
            usedStackView.isHidden = true
            let giftTransaction = giftInfo?.giftTransaction
            var topupRedeemInfo: TopupRedeemInfo?
            /// check thẻ hiện tại có phải thẻ nạp
            /// operation: - 1200: mua thẻ nạp
            ///        -1000:  mua thẻ điện thoại
            if let jsonData = giftTransaction?.description?.data(using: .utf8), let model = try? jsonData.decoded(type: TopupRedeemInfo.self) {
                topupRedeemInfo = model
            }
            // Check Redeem topup
            if usedStatus == EgiftRewardStatus.redeemed.rawValue && whyHaveItType != .sent {
                setUpRedeemTopup(giftInfo: giftInfo, topupRedeemInfo: topupRedeemInfo)
                redeemTopupStackView.isHidden = false
                usedTopupStackView.isHidden = true
            } else {
                // Used egift
                setUpUsedTopup(giftInfo: giftInfo, topupRedeemInfo: topupRedeemInfo)
                setUpUsedEgiftInfo(giftInfo: giftInfo)
                redeemTopupStackView.isHidden = true
                usedTopupStackView.isHidden = false
            }
        } else {
            // Hide Topup
            redeemTopupStackView.isHidden = true
            usedTopupStackView.isHidden = true
            // Check show egit code view
            // Check Redeem egift
            if usedStatus == EgiftRewardStatus.redeemed.rawValue && whyHaveItType != .sent {
                let isUsageCheck = giftInfo?.eGift?.usageCheck ?? false
                if (isUsageCheck) {
                    setUpAutoUpdateStatusEgift(giftInfo: giftInfo)
                    redeemStackView.isHidden = true
                    usedStackView.isHidden = false
                } else {
                    setUpRedeemEgiftInfo(giftInfo: giftInfo)
                    redeemStackView.isHidden = false
                    usedStackView.isHidden = true
                }

            } else {
                // Used egift
                setUpUsedEgiftInfo(giftInfo: giftInfo)
                redeemStackView.isHidden = true
                usedStackView.isHidden = false
            }
        }

    }

    func setUpRedeemEgiftInfo(giftInfo: GiftInfoItem?) {
        let giftTransaction = giftInfo?.giftTransaction
        let code = giftInfo?.eGift?.code
        let serialNo = giftTransaction?.serialNo
        if let code = code, !code.isEmpty {
            redeemCodeLabel.text = code.replacingLastCharacters(with: "XXXX", numberOfReplacedCharacters: 4).uppercased()
            redeemCodeLabel.isHidden = false
        } else {
            redeemCodeLabel.isHidden = true
        }
        if let serialNo = serialNo, !serialNo.isEmpty {
            redeemSerialLabel.text = serialNo.replacingLastCharacters(with: "XXXX", numberOfReplacedCharacters: 4).uppercased()
            redeemSerialStackView.isHidden = false
        } else {
            redeemSerialStackView.isHidden = true
        }

        // Check show hide Send/Use button
        if let whyHaveIt = giftInfo?.giftTransaction?.whyHaveIt {
            sendGiftButton.isHidden = whyHaveIt != WhyHaveRewardType.bought.rawValue
        }
        useButton.isHidden = !viewModel.isShowMarkUsedButton()
    }

    func setUpUsedEgiftInfo(giftInfo: GiftInfoItem?) {
        let giftTransaction = giftInfo?.giftTransaction
        let whyHaveIt = giftTransaction?.whyHaveIt
        let eGift = giftInfo?.eGift
        brandImageView.image = brandImageView.image?.applyColorFilter()
        // Gift code
        if let code = eGift?.code, !code.isEmpty {
            usedCodeLabel.text = code.uppercased()
            usedCodeContainerView.isHidden = false
        } else {
            usedCodeContainerView.isHidden = true
        }
        // Code image
        if let codeImage = giftTransaction?.qrCode {
            if (codeImage.contains("barcode")) {
                qrCodeContainerView.isHidden = true
                barCodeContainerView.isHidden = false
                barCodeImageView.setSDImage(with: codeImage)
            } else {
                qrCodeContainerView.isHidden = false
                barCodeContainerView.isHidden = true
                qrCodeImageView.setSDImage(with: codeImage)
            }
        } else {
            barCodeContainerView.isHidden = true
            if let code = eGift?.code, !code.isEmpty {
                qrCodeContainerView.isHidden = false
                qrCodeImageView.image = UtilHelper.generateQRCode(from: eGift?.code ?? "")
            } else {
                qrCodeContainerView.isHidden = true
            }
        }
        // Serial no
        if let serialNo = giftTransaction?.serialNo, !serialNo.isEmpty {
            usedSerialLabel.text = serialNo.uppercased()
            usedSerialContainerView.isHidden = false
        } else {
            usedSerialContainerView.isHidden = true
        }
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue) {
            usedCodeContainerView.isHidden = true
            usedSerialContainerView.isHidden = true
        }
        // Member name from
        if let memberNameFrom = giftInfo?.memberNameFrom, !memberNameFrom.isEmpty, whyHaveIt == WhyHaveRewardType.received.rawValue {
            memberNameFromLabel.text = "Người tặng: \(memberNameFrom)"
            memberNameFromLabel.isHidden = false
        } else {
            memberNameFromLabel.isHidden = true
        }
        // Ngày xuất voucher
        if let effectiveDate = Date.init(fromString: giftTransaction?.date ?? "", formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy), !effectiveDate.isEmpty {
            effectiveDateLabel.text = "Ngày xuất voucher: \(effectiveDate)"
            effectiveDateLabel.isHidden = false
        } else {
            effectiveDateLabel.isHidden = true
        }

        // Lưu ý
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue) {
            noteLabel.isHidden = true
            qrCodeContainerView.isHidden = true
            barCodeContainerView.isHidden = true
            usedLineView.isHidden = true
        } else {
            noteLabel.isHidden = false
        }
        let attribute1 = "Lưu ý: ".withAttributes([
                .textColor(.cF5574E!),
                .font(.f12s!)
            ])
        let attribute2 = "Không cung cấp ảnh chụp màn hình cho nhân viên để thanh toán.".withAttributes([
                .textColor(.c6D6B7A!),
                .font(.f12r!),
            ])
        noteLabel.attributedText = attribute1 + attribute2

        // Đổi thêm
        let remainingQuantityOfTheGift = giftInfo?.remainingQuantityOfTheGift ?? 0
        let isAvailableToRedeemAgain = giftInfo?.isAvailableToRedeemAgain ?? true
        if (remainingQuantityOfTheGift > 0 && isAvailableToRedeemAgain) {
            reorderButton.isHidden = false
        } else {
            reorderButton.isHidden = true
        }
        sendAutoUpdateStatusGiftButton.isHidden = true
    }

    // Quà đối có usageCheck = true
    // Quà tự động update status
    // CHo hiển thị luôn thông tin quà, mã quà
    func setUpAutoUpdateStatusEgift(giftInfo: GiftInfoItem?) {
        let giftTransaction = giftInfo?.giftTransaction
        let whyHaveIt = giftTransaction?.whyHaveIt
        let eGift = giftInfo?.eGift
        // Gift code
        if let code = eGift?.code, !code.isEmpty {
            usedCodeLabel.text = code.uppercased()
            usedCodeContainerView.isHidden = false
        } else {
            usedCodeContainerView.isHidden = true
        }
        // Code image
        barCodeContainerView.isHidden = true
        if let codeImage = giftTransaction?.qrCode {

            if (codeImage.contains("barcode")) {
                qrCodeContainerView.isHidden = true
                barCodeContainerView.isHidden = false
                barCodeImageView.setSDImage(with: codeImage)
            } else {
                qrCodeContainerView.isHidden = false
                barCodeContainerView.isHidden = true
                qrCodeImageView.setSDImage(with: codeImage)
            }

        } else {
            if let code = eGift?.code, !code.isEmpty {
                qrCodeContainerView.isHidden = false
                qrCodeImageView.image = UtilHelper.generateQRCode(from: eGift?.code ?? "")
            } else {
                qrCodeContainerView.isHidden = true
            }
        }
        // Serial no
        if let serialNo = giftTransaction?.serialNo, !serialNo.isEmpty {
            usedSerialLabel.text = serialNo.uppercased()
            usedSerialContainerView.isHidden = false
        } else {
            usedSerialContainerView.isHidden = true
        }
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue) {
            usedCodeContainerView.isHidden = true
            usedSerialContainerView.isHidden = true
        }
        // Member name from
        if let memberNameFrom = giftInfo?.memberNameFrom, !memberNameFrom.isEmpty, whyHaveIt == WhyHaveRewardType.received.rawValue {
            memberNameFromLabel.text = "Người tặng: \(memberNameFrom)"
            memberNameFromLabel.isHidden = false
        } else {
            memberNameFromLabel.isHidden = true
        }
        // Ngày xuất voucher
        if let effectiveDate = Date.init(fromString: giftTransaction?.date ?? "", formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy), !effectiveDate.isEmpty {
            effectiveDateLabel.text = "Ngày xuất voucher: \(effectiveDate)"
            effectiveDateLabel.isHidden = false
        } else {
            effectiveDateLabel.isHidden = true
        }

        // Lưu ý
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue) {
            noteLabel.isHidden = true
            qrCodeContainerView.isHidden = true
            barCodeContainerView.isHidden = true
            usedLineView.isHidden = true
        } else {
            noteLabel.isHidden = false
        }
        let attribute1 = "Lưu ý: ".withAttributes([
                .textColor(.cF5574E!),
                .font(.f12s!)
            ])
        let attribute2 = "Không cung cấp ảnh chụp màn hình cho nhân viên để thanh toán.".withAttributes([
                .textColor(.c6D6B7A!),
                .font(.f12r!),
            ])
        noteLabel.attributedText = attribute1 + attribute2

        // Đổi thêm
        reorderButton.isHidden = true
        // Check show hide Send/Use button
        if let whyHaveIt = giftInfo?.giftTransaction?.whyHaveIt {
            sendAutoUpdateStatusGiftButton.isHidden = whyHaveIt != WhyHaveRewardType.bought.rawValue
        }
    }

    // Thông tin chung
    func setUpGeneralInfo(_ giftTransaction: GiftTransaction) {
        // Giới thiệu
        if let description = giftTransaction.giftDescription, !description.isEmpty {
            descriptionStackView.isHidden = false
            descriptionWebView.getWebView(withHTMLContent: description, withStyle: .webViewDetail)
            descriptionWebView.reload()

        } else {
            descriptionStackView.isHidden = true
        }

        // Hướng dẫn sử dụng
        if let introduce = giftTransaction.introduce, !introduce.isEmpty {
            instructionContainerView.isHidden = false
            instructionWebView.getWebView(withHTMLContent: viewModel.parseIntroduce(introduce), withStyle: .webViewDetail)
            instructionWebView.reload()
        } else {
            instructionContainerView.isHidden = true
        }

        // Liên hệ
        if (!(giftTransaction.contactHotline ?? "").isEmpty || !(giftTransaction.contactEmail ?? "").isEmpty) {
            contactContainerView.isHidden = false
            if let email = giftTransaction.contactEmail, !email.isEmpty {
                emailContainerView.isHidden = false
                emailButton.setTitle(email, for: .normal)
            } else {
                emailContainerView.isHidden = true
            }
            if let hotline = giftTransaction.contactHotline, !hotline.isEmpty {
                hotlineContainerView.isHidden = false
                hotlineButton.setTitle(hotline, for: .normal)
            } else {
                hotlineContainerView.isHidden = true
            }
        } else {
            contactContainerView.isHidden = true
        }
        giftInfoContainerView.isHidden = descriptionStackView.isHidden && instructionContainerView.isHidden && contactContainerView.isHidden
        // Điều kiện áp dụng
        if let condition = giftTransaction.condition, !condition.isEmpty {
            conditionContainerView.isHidden = false
            conditionWebView.getWebView(withHTMLContent: condition, withStyle: .webViewDetail)
            instructionWebView.reload()
        } else {
            conditionContainerView.isHidden = true
        }
    }
}

// MARK: Thông tin quà TopUp
extension EgiftRewardDetailViewController {

    func setUpRedeemTopup(giftInfo: GiftInfoItem?, topupRedeemInfo: TopupRedeemInfo?) {
        let giftTransaction = giftInfo?.giftTransaction
        let serialNo = giftTransaction?.serialNo ?? ""
        let code = giftInfo?.eGift?.code ?? ""
        if !code.isEmpty {
            redeemTopupCodeLabel.text = code
            redeemTopupCodeLabel.isHidden = false
        } else {
            redeemTopupCodeLabel.isHidden = true
        }
        if !serialNo.isEmpty {
            redeemSeriTopupLabel.text = serialNo
            redeemSeriTopupLabel.isHidden = false
        } else {
            redeemSeriTopupLabel.isHidden = true
        }
        redeemTopupCodeContainerView.isHidden = code.isEmpty && serialNo.isEmpty

        // Check remaining
        let remainingQuantityOfTheGift = giftInfo?.remainingQuantityOfTheGift ?? 0
        let isAvailableToRedeemAgain = giftInfo?.isAvailableToRedeemAgain ?? true
        // Check show Send button
        let whyHaveItType = giftTransaction?.whyHaveItType
        let isShowSendButton = whyHaveItType == .bought
        // Check show redeem butotn
        /// điều kiện hiển thị nút Nạp Ngay:
        /// - là thẻ điện thoại đã mua, không phải thẻ Topup
        /// - cú giá trả syntax trả về
        let isTopup = topupRedeemInfo?.operation == 1200
        let syntax = giftTransaction?.introduce ?? ""
        let isShowTopupButton = !isTopup && !syntax.isEmpty
        // Check reorder button
        let isShowReorderButton = whyHaveItType == .received && remainingQuantityOfTheGift > 0 && isAvailableToRedeemAgain

        // Chỉ hiển thị nút Nạp ngay
        redeemTopupButtonStackView.isHidden = !(isShowSendButton || isShowTopupButton || isShowReorderButton)
        if (isShowTopupButton && !isShowSendButton && !isShowReorderButton) {
            leftTopupButton.isHidden = true
            rightTopupButton.isHidden = false
            rightTopupButton.setTitle("Nạp ngay", for: .normal)
            rightTopupButton.rx.tap
                .subscribe(onNext: { [weak self] in
                self?.onTopupAction()
            })
                .disposed(by: disposeBag)
        }

        // Chỉ hiển thị nút Tặng bạn bè
        if (isShowSendButton && !isShowTopupButton) {
            leftTopupButton.isHidden = false
            rightTopupButton.isHidden = true
            leftTopupButton.setTitle("Tặng bạn bè", for: .normal)
            rightTopupButton.rx.tap
                .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                UtilHelper.showInstallAppPopup(parentVC: self)
            })
                .disposed(by: disposeBag)
        }

        // Chỉ hiển thị nút đổi thêm
        if (isShowReorderButton && !isShowSendButton) {
            leftTopupButton.isHidden = true
            rightTopupButton.isHidden = false
            rightTopupButton.setTitle("Đổi thêm", for: .normal)
            rightTopupButton.rx.tap
                .subscribe(onNext: { [weak self] in
                self?.onReorderTopupAction()
            })
                .disposed(by: disposeBag)
        }

        // Hiển thị nút Tặng bạn bè + Nạp ngay
        if (isShowTopupButton && isShowSendButton) {
            leftTopupButton.isHidden = false
            rightTopupButton.isHidden = false
            leftTopupButton.setTitle("Tặng bạn bè", for: .normal)
            leftTopupButton.rx.tap
                .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                UtilHelper.showInstallAppPopup(parentVC: self)
            })
                .disposed(by: disposeBag)
            rightTopupButton.setTitle("Nạp ngay", for: .normal)
            rightTopupButton.rx.tap
                .subscribe(onNext: { [weak self] in
                self?.onTopupAction()
            })
                .disposed(by: disposeBag)
        }

        // Hiển thị nút Đổi thêm + Nạp ngay
        if (isShowReorderButton && isShowTopupButton) {
            leftTopupButton.isHidden = false
            rightTopupButton.isHidden = false
            leftTopupButton.setTitle("Đổi thêm", for: .normal)
            leftTopupButton.rx.tap
                .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                onReorderTopupAction()
            })
                .disposed(by: disposeBag)
            rightTopupButton.setTitle("Nạp ngay", for: .normal)
            rightTopupButton.rx.tap
                .subscribe(onNext: { [weak self] in
                self?.onTopupAction()
            })
                .disposed(by: disposeBag)
        }

    }

    func setUpUsedTopup(giftInfo: GiftInfoItem?, topupRedeemInfo: TopupRedeemInfo?) {
        let giftTransaction = giftInfo?.giftTransaction
        let code = giftInfo?.eGift?.code ?? ""
        if !code.isEmpty {
            usedTopupCodeLabel.text = code
            usedTopupCodeLabel.isHidden = false
        } else {
            usedTopupCodeLabel.isHidden = true
        }
        let serialNo = giftTransaction?.serialNo ?? ""
        if !serialNo.isEmpty {
            usedSeriTopupLabel.text = serialNo
            usedSeriTopupLabel.isHidden = false
        } else {
            usedSeriTopupLabel.isHidden = true
        }
        usedTopupCodeContainerView.isHidden = code.isEmpty && serialNo.isEmpty

        let isTopup = topupRedeemInfo?.operation == 1200;
        let receipentPhone = topupRedeemInfo?.ownerPhone ?? ""
        if (isTopup && !receipentPhone.isEmpty) {
            topupPhoneNumberLabel.text = "Số điện thoại nạp: \(receipentPhone)"
            topupPhoneNumberLabel.isHidden = false
        } else {
            topupPhoneNumberLabel.isHidden = true
        }

        // Đổi thêm
        let remainingQuantityOfTheGift = giftInfo?.remainingQuantityOfTheGift ?? 0
        let isAvailableToRedeemAgain = giftInfo?.isAvailableToRedeemAgain ?? true
        if (remainingQuantityOfTheGift > 0 && isAvailableToRedeemAgain) {
            reorderTopupButton.isHidden = false
        } else {
            reorderTopupButton.isHidden = true
        }

    }

    func copyCodeAndSeriTopup() {
        self.navigator.show(segue: .topupPopup(data: TopupPopupArgument(
            list: viewModel.getListCodeAndSeri(),
            type: .copy,
            onSelected: { [weak self] data in
                UtilHelper.copyToClipboard(text: data.detail) {
                    self?.showToast(ofType: .success, withMessage: "Sao chép thành công")
                }
            }))) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
    }

    // Nạp ngay
    func onTopupAction() {
        navigator.show(segue: .markUsed(didFinish: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let topupPhoneList = self.viewModel.getListTopupPhoneSyntax()
                if !topupPhoneList.isEmpty {
                    self.navigator.show(segue: .topupPopup(data: TopupPopupArgument(
                        list: topupPhoneList,
                        type: .copy,
                        onSelected: { [weak self] data in
                            guard let self = self else { return }
                            UtilHelper.openPhoneCall(number: data.detail)
                            // TODO: update gift status
                             self.viewModel.updateEgiftStatus()
                        }))) { [weak self] vc in
                        guard let self = self else { return }
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.navigationController?.present(vc, animated: true)
                    }
                } else if let data = self.viewModel.getToupDataSyntax(), let syntax = data.syntax, let toPhone = data.toNumber {
                    self.viewModel.updateEgiftStatus()
                    let urlString = "sms:\(toPhone)&body=\(syntax)"
                    UtilHelper.openURL(urlString: urlString)
                }
            }
        })) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
    }

    // Đổi thêm
    func onReorderTopupAction() {
        let topupType = viewModel.output.giftInfo.value?.topupType ?? .topupPhone
        self.navigator.show(segue: .topup(topupType: topupType)) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}

extension EgiftRewardDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch webView {
        case descriptionWebView:
            if (isInjectedDescriptionWebView) {
                return
            }
            isInjectedDescriptionWebView = true
            webView.injectJavascript(superView: self.view, webViewHeightConstraint: descriptionWebViewHeightConstraint)
            break
        case instructionWebView:
            if (isInjectedInstructionWebView) {
                return
            }
            isInjectedInstructionWebView = true
            webView.injectJavascript(superView: self.view, webViewHeightConstraint: instructionWebViewHeightConstraint)
            break
        case conditionWebView:
            if (isInjectedConditionWebView) {
                return
            }
            isInjectedConditionWebView = true
            webView.injectJavascript(superView: self.view, webViewHeightConstraint: conditionWebViewHeightConstraint)
            break
        default: break

        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                // Open in web view
                decisionHandler(.allow)
            }
        } else {
            // other navigation type, such as reload, back or forward buttons
            decisionHandler(.allow)
        }
    }
}


extension EgiftRewardDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.output.giftInfo.value?.giftUsageAddress?.count ?? 0
        return min(count, 3)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueCell(ofType: GiftLocationTableViewCell.self, for: indexPath)
        let list = viewModel.output.giftInfo.value?.giftUsageAddress ?? []
        cell.setDataForCell(data: list[indexPath.row], isLastItem: indexPath.row == list.count - 1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.output.giftInfo.value?.giftUsageAddress?[indexPath.row]
        UtilHelper.openGoogleMap(navigator: self.navigator, parentVC: self, address: data?.address ?? "")
    }
}

extension EgiftRewardDetailViewController {

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

extension EgiftRewardDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shrinkOffset = self.scrollView.contentOffset.y
        let headerViewBottom = self.headerView.frame.origin.y + self.headerView.frame.size.height

        let alpha: CGFloat = {
            let _alpha = (headerViewBottom - shrinkOffset) / headerViewBottom
            return _alpha
        }()
        self.headerView.alpha = 1 - alpha
        self.headerView.isHidden = alpha == 0
    }
}

//
//  GiftDetailViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/05/2024.
//

import UIKit
import WebKit
import EasyTipView
import iCarousel
import SwiftyAttributes

class GiftDetailDiamondViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: GiftDetailDiamondViewModel) -> Self {
        let vc = UIStoryboard.diamond.instantiateViewController(ofType: GiftDetailDiamondViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }


    @IBOutlet weak var scrollView: UIScrollView!
    // Header
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var indexCarouselLabel: UILabel!
    @IBOutlet weak var indexCarouselView: UIView!
    @IBOutlet weak var floatNavView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var installAppView: InstallAppBannerSmallView!

    // Giá quà
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var requiredCoinLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!
    @IBOutlet weak var discountContainerView: UIView!
    @IBOutlet weak var discountCoinLabel: UILabel!
    // Hạn sử dụng
    @IBOutlet weak var expiredDateInfoButton: UIButton!
    @IBOutlet weak var expiredDatelabel: UILabel!
    @IBOutlet weak var expiredStackView: UIStackView!
    // Tích thêm điểm
    @IBOutlet weak var earnCoinContainerView: UIView!
    @IBOutlet weak var earnCoinLabel: UILabel!

    // Mô tả chung
    @IBOutlet weak var giftInfoContainerView: UIView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var descriptionWebView: WKWebView!
    @IBOutlet weak var descriptionWebViewHeightConstraint: NSLayoutConstraint!

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
    // Trợ giúp
    @IBOutlet weak var supportImageView: UIImageView!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    // Button
    @IBOutlet weak var remainingQuantityLabel: UILabel!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var exchangeButtonContainerView: UIView!

    var viewModel: GiftDetailDiamondViewModel!

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
//        self.showNavigationBar()
        locationTableView.removeObserver(self, forKeyPath: "contentSize")
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
        view.setDiamondBackgroundGradient()
        exchangeButton.setDiamondButtonGradient()
        floatNavView.setDiamondHeaderGradient()
        earnCoinContainerView.setGradient(colors: [.cFFD833!.withAlphaComponent(0.1), .cFE9E32!.withAlphaComponent(0.1)], direction: .right)
        installAppView.configureUI()
    }

    override func setImage() {
        supportImageView.image = .iconSupportYellow
        arrowRightImageView.image = .iconArrowRightYellow
    }

    override func initView() {
        descriptionWebView.navigationDelegate = self
        instructionWebView.navigationDelegate = self
        conditionWebView.navigationDelegate = self

        locationTableView.register(cellType: GiftLocationTableViewCell.self)
        self.setUpEasyView(tipView: &tipView)
        // Carousel
        self.setUpCarousel(carousel: carousel)
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
    }

    @objc func handleTimer() {
        var newIndex = carousel.currentItemIndex + 1
        if newIndex > carousel.numberOfItems {
            newIndex = 0
        }
        carousel.scrollToItem(at: newIndex, duration: 0.5)
    }


    override func bindToView() {
        // Loading
        viewModel.output.isLoading.subscribe { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                showDiamondLoading()
            } else {
                hideLoading()
            }
        }.disposed(by: disposeBag)
        // Reward info
        viewModel.output.giftInfo.subscribe(onNext: { [weak self] giftInfo in
            guard let self = self else { return }
            // Ảnh quà
            if let imageLink = giftInfo?.imageLink {
                setUpGiftImage(imageLink)
            }
            if let giftInfor = giftInfo?.giftInfor {
                self.scrollView.isHidden = false
                exchangeButtonContainerView.isHidden = false
                // Giá quà
                setUpGiftPirce(giftInfor)

                // Thông tin chung
                setUpGeneralInfo(giftInfor)

                // Địa điểm áp dụng
                setUpLocation(giftInfo?.giftUsageAddress)

                // Button Đổi ngay
                setUpExchangeButton()
            } else {
                scrollView.isHidden = true
                exchangeButtonContainerView.isHidden = true
            }
        }).disposed(by: disposeBag)

        // Kiểm tra có phải khách hàng AF không
        viewModel.input.getMemberVpbankInforResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isAFCustomer):
                if (isAFCustomer) {
                    if let giftInfo = viewModel.output.giftInfo.value {
                        if giftInfo.giftInfor?.isEGift ?? true {
                            navigator.show(segue: .diamondExchangeConfirm(
                                data: GiftConfirmExchangeArguments(giftsRepository: GiftsRepositoryImpl(),
                                    giftInfo: giftInfo,
                                    giftExchangePrice: viewModel.getDisplayPrice()
                                )), withAction: { [weak self] vc in
                                    self?.navigationController?.pushViewController(vc, animated: true)
                                })
                        } else {
                            navigator.show(segue: .diamondPhysicalShipping(
                                giftInfo: giftInfo,
                                giftExchangePrice: viewModel.getDisplayPrice()
                                ), withAction: { [weak self] vc in
                                    self?.navigationController?.pushViewController(vc, animated: true)
                                })
                        }
                    }
                } else {
                    navigator.show(segue: .diamondExchangeError) { [weak self] vc in
                        guard let self = self else { return }
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self.navigationController?.present(vc, animated: true)

                    }
                }
                break
            case .failure(let res):
                UtilHelper.showAPIErrorPopUp(parentVC: self,
                    message: res.message ?? "")
            }
        }).disposed(by: disposeBag)

        exchangeButton.rx.tap
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            // Chưa đăng nhập hiển thị popup đăng nhập
            if (AppConfig.shared.viewMode == .anonymous) {
                self.navigator.show(segue: .popupLogin(isDiamond: true)) { [weak self] vc in
                    guard let self = self else { return }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.navigationController?.present(vc, animated: true)
                }
                return
            }
            viewModel.getMemberVpbankInfor()
        })
            .disposed(by: disposeBag)

    }

    // Ảnh quà
    func setUpGiftImage(_ imageLinks: [ImageLinkModel]?) {
        let isScrollImageEnable: Bool = imageLinks?.count ?? 0 > 1
        indexCarouselView.isHidden = !isScrollImageEnable
        carousel.isScrollEnabled = isScrollImageEnable
        giftImageView.isHidden = imageLinks?.count ?? 0 != 0
        carousel.reloadData()
    }

    // Giá quà
    func setUpGiftPirce(_ giftInfor: GiftInfor) {
        giftNameLabel.text = giftInfor.name
        let requiredCoin = giftInfor.requiredCoin ?? 0
        self.requiredCoinLabel.text = requiredCoin.formatter()
        let fullPrice = giftInfor.fullPrice ?? 0
        if fullPrice > requiredCoin {
            fullPriceLabel.isHidden = false
            fullPriceLabel.text = fullPrice.formatter()
            fullPriceLabel.strikeThrough()
        } else {
            fullPriceLabel.isHidden = true
        }
        if let discountPrice = giftInfor.discountPrice, discountPrice > 0 {
            discountCoinLabel.text = "-\(Int(discountPrice))%"
            discountContainerView.isHidden = false
        } else {
            discountContainerView.isHidden = true
        }

        // Hạn sử dụng
        if let expiredDateString = viewModel.getDisplayDateString(expiredDate: giftInfor.expireDuration) {
            expiredDatelabel.text = expiredDateString
            expiredStackView.isHidden = false
        } else {
            expiredStackView.isHidden = true
        }
        // Tích điểm
        if !viewModel.getEarnMoreCoinString().isEmpty {
            let attribute1 = "\(viewModel.getEarnMoreCoinString())".withAttributes([
                    .textColor(.white),
                    .font(.f14r!)
                ])
            let attribute2 = " Khám phá ngay".withAttributes([
                    .textColor(.cE9B161!),
                    .font(.f14s!)
                ])
            earnCoinLabel.attributedText = attribute1 + attribute2
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
            tapGesture.numberOfTouchesRequired = 1
            earnCoinLabel.addGestureRecognizer(tapGesture)
            earnCoinLabel.isUserInteractionEnabled = true
            earnCoinContainerView.isHidden = false
        } else {
            earnCoinContainerView.isHidden = true
        }
    }

    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = earnCoinLabel.text else { return }
        let explore = (text as NSString).range(of: "Khám phá ngay")
        if gesture.didTapAttributedTextInLabel(label: self.earnCoinLabel, inRange: explore) {
            UtilHelper.showInstallAppPopup(parentVC: self, isVpbankDiamond: true)
        }
    }

    // Thông tin chung
    func setUpGeneralInfo(_ giftInfor: GiftInfor) {
        // Giới thiệu
        if let description = giftInfor.description, !description.isEmpty {
            descriptionStackView.isHidden = false
            descriptionWebView.getWebView(withHTMLContent: description, withStyle: .webViewDiamond)
            descriptionWebView.reload()

        } else {
            descriptionStackView.isHidden = true
        }

        // Hướng dẫn sử dụng
        if let introduce = giftInfor.introduce, !introduce.isEmpty {
            instructionContainerView.isHidden = false
            instructionWebView.getWebView(withHTMLContent: introduce, withStyle: .webViewDiamond)
            instructionWebView.reload()
        } else {
            instructionContainerView.isHidden = true
        }

        // Liên hệ
        if (!(giftInfor.contactHotline ?? "").isEmpty || !(giftInfor.contactEmail ?? "").isEmpty) {
            contactContainerView.isHidden = false
            if let email = giftInfor.contactEmail, !email.isEmpty {
                emailContainerView.isHidden = false
                emailButton.setTitle(email, for: .normal)
            } else {
                emailContainerView.isHidden = true
            }
            if let hotline = giftInfor.contactHotline, !hotline.isEmpty {
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
        if let condition = giftInfor.condition, !condition.isEmpty {
            conditionContainerView.isHidden = false
            conditionWebView.getWebView(withHTMLContent: condition, withStyle: .webViewDiamond)
            conditionWebView.reload()
        } else {
            conditionContainerView.isHidden = true
        }
    }

    // Địa điểm áp dụng
    func setUpLocation(_ locatons: [GiftUsageLocationItem]?) {
        if let locatons = locatons, locatons.count > 0 {
            locationContainerView.isHidden = false
            loadMoreLocationButton.isHidden = locatons.count < 3
        } else {
            loadMoreLocationButton.isHidden = true
            locationContainerView.isHidden = true
        }
        locationTableView.reloadData()
    }

    // Button Đổi ngay
    func setUpExchangeButton() {
        if (viewModel.checkEnableButton()) {
            exchangeButton.enable()
        } else {
            exchangeButton.disable()
        }

        let remainingTurn = viewModel.getRemaningTurnExchange()
        if remainingTurn.isEmpty {
            remainingQuantityLabel.text = remainingTurn
            remainingQuantityLabel.isHidden = true
        } else {
            remainingQuantityLabel.isHidden = false
        }
        exchangeButton.setTitle(viewModel.getTitleButton(), for: .normal)
    }

// MARK: -Actions
    @IBAction func onBackPressed(_ sender: Any) {
        self.pop()
    }

    @IBAction func openEmailAction(_ sender: Any) {
        if let email = viewModel.output.giftInfo.value?.giftInfor?.contactEmail {
            UtilHelper.openEmail(email: email)
        }
    }

    @IBAction func callHotlineAction(_ sender: Any) {
        if let phone = viewModel.output.giftInfo.value?.giftInfor?.contactHotline {
            UtilHelper.openPhoneCall(number: phone)
        }
    }

    @IBAction func seeMoreLocationAction(_ sender: Any) {
        self.navigator.show(segue: .diamondLocation(giftCode: viewModel.output.giftInfo.value?.giftInfor?.code ?? "")) { [weak self] vc in
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




    @IBAction func callSupportCenterAction(_ sender: Any) {
        UtilHelper.callVpBankDiamondHotLine()
    }

}

extension GiftDetailDiamondViewController: WKNavigationDelegate {
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

extension GiftDetailDiamondViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.setDataForCell(data: list[indexPath.row], isLastItem: indexPath.row == list.count - 1, isDiamond: true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.output.giftInfo.value?.giftUsageAddress?[indexPath.row]
        UtilHelper.openGoogleMap(navigator: self.navigator, parentVC: self, address: data?.address ?? "")
    }
}

extension GiftDetailDiamondViewController: iCarouselDataSource, iCarouselDelegate {

    // MARK: - iCarousel Datasource

    func numberOfItems(in carousel: iCarousel) -> Int {
        let count = viewModel.output.giftInfo.value?.imageLink?.count ?? 0
        return count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView: UIImageView

        if view != nil {
            imageView = view as! UIImageView
        } else {
            imageView = UIImageView(frame: self.carousel.frame)
        }
        let imageLinks = viewModel.output.giftInfo.value?.imageLink ?? []

        imageView.setSDImage(with: imageLinks[index].fullLink)
        imageView.layer.masksToBounds = true

        return imageView
    }

    // MARK: - iCarousel Delegate


    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing:
            return value * 1.05
        case .visibleItems:
            return 3.0
        case .wrap:
            return 1
        default:
            return value
        }
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.indexCarouselLabel.text = "\(carousel.currentItemIndex + 1)/\(viewModel.output.giftInfo.value?.imageLink?.count ?? 0)"
    }
}

extension GiftDetailDiamondViewController {

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

extension GiftDetailDiamondViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Convert the targetView's frame to the scrollView's coordinate system
        let targetFrameInScrollView = giftInfoContainerView.convert(giftInfoContainerView.bounds, to: scrollView)

        // The content offset of the scrollView
        let contentOffset = scrollView.contentOffset

        // Calculate the content offset of the target view inside the scroll view
        let offsetX = targetFrameInScrollView.origin.x - contentOffset.x
        let offsetY = targetFrameInScrollView.origin.y - contentOffset.y

        let navHeight = self.floatNavView.frame.height
        let alpha: CGFloat = {
            let _alpha = (navHeight - offsetY) / navHeight
            return _alpha + 0.9
        }()
        floatNavView.isHidden = navHeight < offsetY
        floatNavView.alpha = alpha

    }
}


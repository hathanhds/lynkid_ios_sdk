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

class GiftDetailViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: GiftDetailViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: GiftDetailViewController.self)
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
    @IBOutlet weak var icPhoneImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    // Flash sale
    @IBOutlet weak var flashSaleContainerView: UIView!
    @IBOutlet weak var flashSaleHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var flashSaleDiscountLabel: UILabel!
    @IBOutlet weak var flashSaleReqiredCoinLabel: UILabel!
    @IBOutlet weak var flashSaleFullPriceLabel: UILabel!
    @IBOutlet weak var flashSaleRemainingGiftLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var icCoinFlashSale: UIImageView!
    @IBOutlet weak var flashSaleStatusTitleLabel: UILabel!

    // Giá quà
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var requiredCoinLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!
    @IBOutlet weak var discountContainerView: UIView!
    @IBOutlet weak var discountCoinLabel: UILabel!
    @IBOutlet weak var giftPriceStackView: UIStackView!

    // Hạn sử dụng
    @IBOutlet weak var expiredDateInfoButton: UIButton!
    @IBOutlet weak var expiredDatelabel: UILabel!
    @IBOutlet weak var expiredStackView: UIStackView!
    // Tích thêm điểm
    @IBOutlet weak var earnCoinContainerView: EarnPointView!
    @IBOutlet weak var earnCoinLabel: UILabel!
    @IBOutlet weak var iconBellImageView: UIImageView!

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
    // Button
    @IBOutlet weak var remainingQuantityLabel: UILabel!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var exchangeButtonContainerView: UIView!

    // Float bar
    @IBOutlet weak var backNavButton: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var iconCoinImageView: UIImageView!


    var viewModel: GiftDetailViewModel!

    private var isInjectedDescriptionWebView: Bool = false
    private var isInjectedInstructionWebView: Bool = false
    private var isInjectedConditionWebView: Bool = false

    var tipView = EasyTipView(text: "")
    var counter = 0
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        locationTableView.allowsSelection = true
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
        backNavButton.setImage(with: .iconBack)
        backImageView.image = .iconBack
        icPhoneImageView.image = .iconPhoneInstall
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
        exchangeButton.setCommonGradient()
        floatNavView.setCommonGradient()
        installAppView.configureUI()
    }

    override func initView() {
        descriptionWebView.navigationDelegate = self
        instructionWebView.navigationDelegate = self
        conditionWebView.navigationDelegate = self

        fullPriceLabel.strikeThrough()
        flashSaleFullPriceLabel.strikeThrough()
        locationTableView.register(cellType: GiftLocationTableViewCell.self)
        self.setUpEasyView(tipView: &tipView)
        earnCoinContainerView.initView(fromVC: self)

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
                showLoading()
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

                // Flash sale
                setUpFlashSale(giftInfo)

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

        exchangeButton.rx.tap
            .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            // Chưa đăng nhập hiển thị popup đăng nhập
            if (AppConfig.shared.viewMode == .anonymous) {
                self.navigator.show(segue: .popupLogin(isDiamond: false)) { [weak self] vc in
                    guard let self = self else { return }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.navigationController?.present(vc, animated: true)
                }
                return
            }

            // Flash sale
            if (FlashSale.shared.isShowFlashSale) {
                self.navigator.show(segue: .flashSalePopup) { [weak self] vc in
                    vc.modalPresentationStyle = .fullScreen
                    self?.navigationController?.present(vc, animated: true)
                }
                return
            }
            // Luồng đổi quà thường
            if let giftInfo = viewModel.output.giftInfo.value {
                if giftInfo.giftInfor?.isEGift ?? true {
                    navigator.show(segue: .giftExchangeConfirm(
                        data: GiftConfirmExchangeArguments(giftsRepository: GiftsRepositoryImpl(),
                            giftInfo: giftInfo,
                            giftExchangePrice: viewModel.getDisplayPrice()
                        )), withAction: { [weak self] vc in
                            self?.navigationController?.pushViewController(vc, animated: true)
                        })
                } else {
                    navigator.show(segue: .physicalShipping(
                        giftInfo: giftInfo,
                        giftExchangePrice: viewModel.getDisplayPrice()
                        ), withAction: { [weak self] vc in
                            self?.navigationController?.pushViewController(vc, animated: true)
                        })
                }

            }
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
        let earnMoreCoin = viewModel.getEarnMoreCoin()
        if earnMoreCoin > 0 {
            earnCoinContainerView.earnMoreCoin = earnMoreCoin
            earnCoinContainerView.isHidden = false
        } else {
            earnCoinContainerView.isHidden = true
        }
    }

    func setUpFlashSale(_ giftInfo: GiftInfoItem?) {
        FlashSale.shared.setupData(giftInfo)
        let giftInfor = giftInfo?.giftInfor
        let giftDiscountInfor = giftInfo?.giftDiscountInfor
        let fullPrice = giftInfor?.fullPrice ?? 0
        let salePrice = giftDiscountInfor?.salePrice ?? 0
        let reductionRateDisplay = giftDiscountInfor?.reductionRateDisplay ?? 0

        flashSaleFullPriceLabel.text = fullPrice.formatter()
        flashSaleReqiredCoinLabel.text = salePrice.formatter()
        flashSaleDiscountLabel.text = "-\(reductionRateDisplay.formatter())%"
        FlashSale.shared.totalTime.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            hourLabel.text = FlashSale.shared.getHours
            minuteLabel.text = FlashSale.shared.getMinutes
            secondLabel.text = FlashSale.shared.getSeconds
            flashSaleRemainingGiftLabel.text = FlashSale.shared.getGiftRemaningTitle
            flashSaleStatusTitleLabel.text = FlashSale.shared.getGiftStatusTitle

            giftPriceStackView.isHidden = FlashSale.shared.isShowFlashSale
            flashSaleContainerView.isHidden = !FlashSale.shared.isShowFlashSale
        }).disposed(by: disposeBag)


    }

    // Thông tin chung
    func setUpGeneralInfo(_ giftInfor: GiftInfor) {
        // Giới thiệu
        if let description = giftInfor.description, !description.trim().isEmpty {
            descriptionStackView.isHidden = false
            descriptionWebView.getWebView(withHTMLContent: description, withStyle: .webViewDetail)
            descriptionWebView.reload()

        } else {
            descriptionStackView.isHidden = true
        }

        // Hướng dẫn sử dụng
        if let introduce = giftInfor.introduce, !introduce.trim().isEmpty {
            instructionContainerView.isHidden = false
            instructionWebView.getWebView(withHTMLContent: introduce, withStyle: .webViewDetail)
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
        if let condition = giftInfor.condition, !condition.trim().isEmpty {
            conditionContainerView.isHidden = false
            conditionWebView.getWebView(withHTMLContent: condition, withStyle: .webViewDetail)
            instructionWebView.reload()
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
        if !remainingTurn.isEmpty {
            remainingQuantityLabel.text = remainingTurn
            remainingQuantityLabel.isHidden = false
        } else {
            remainingQuantityLabel.isHidden = true
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
        self.navigator.show(segue: .giftLocation(giftCode: viewModel.output.giftInfo.value?.giftInfor?.code ?? "")) { [weak self] vc in
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


    @IBAction func installAppAction(_ sender: Any) {
        UtilHelper.openLynkiDAPP()
    }
}

extension GiftDetailViewController: WKNavigationDelegate {
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

extension GiftDetailViewController: UITableViewDelegate, UITableViewDataSource {
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

extension GiftDetailViewController: iCarouselDataSource, iCarouselDelegate {

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

extension GiftDetailViewController {

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

extension GiftDetailViewController: UIScrollViewDelegate {
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


//
//  RewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import WebKit
import iCarousel

class PhysicalRewardDetailViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: PhysicalRewardDetailViewModel) -> Self {
        let vc = UIStoryboard.myReward.instantiateViewController(ofType: PhysicalRewardDetailViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    @IBOutlet weak var _ticketView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!

    // Header
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var carouselPlaceholderImageView: UIImageView!
    @IBOutlet weak var indexCarouselLabel: UILabel!
    @IBOutlet weak var indexCarouselView: UIView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var bgHeaderImageView: UIImageView!
    @IBOutlet weak var installAppView: InstallAppBannerSmallView!

    // Thông tin vận chuyển
    @IBOutlet weak var statusCollectionView: UICollectionView!
    @IBOutlet weak var cancelReasonContainerView: UIView!
    @IBOutlet weak var reasonLabel: UILabel!

    // Thông tin nhận hàng
    @IBOutlet weak var shipInfoContainerView: UIView!

    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var shipPhoneStackView: UIStackView!
    @IBOutlet weak var shipPhoneLabel: UILabel!
    @IBOutlet weak var shipLocationStackView: UIStackView!
    @IBOutlet weak var shipLocationLabel: UILabel!
    @IBOutlet weak var shipNoteStackView: UIStackView!
    @IBOutlet weak var shipNoteLabel: UILabel!

    // Thông tin khác
    @IBOutlet weak var otherInfoContainerView: UIView!
    @IBOutlet weak var exchangeDateLabel: UILabel!
    @IBOutlet weak var exchangeDateStackView: UIStackView!
    @IBOutlet weak var hotlineVendorStackView: UIStackView!
    @IBOutlet weak var hotlineVendorButton: UIButton!

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


    var viewModel: PhysicalRewardDetailViewModel!
    private var isInjectedDescriptionWebView: Bool = false
    private var isInjectedInstructionWebView: Bool = false
    private var isInjectedConditionWebView: Bool = false

    let progressIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
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
        headerView.setCommonGradient()
        installAppView.configureUI()
    }

    override func setImage() {
        bgHeaderImageView.image = .bgHeader
    }

    override func initView() {
        descriptionWebView.navigationDelegate = self
        instructionWebView.navigationDelegate = self
        conditionWebView.navigationDelegate = self
        // Carousel
        carouselPlaceholderImageView.isHidden = true
        indexCarouselView.isHidden = true
        setUpCarousel(carousel: carousel, cornerRadius: 0)
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
            if let giftTransaction = giftInfo?.giftTransaction {
                scrollView.isHidden = false
                // Header
                setUpHeaderInfo(giftTransaction, giftInfo?.imageLinks)
                //  Thông tin vận chuyển
                setUpProgressTransaction(giftTransaction)
                // Thông tin khác
                setUpOtherInfo(giftTransaction, giftInfo?.vendorInfo?.hotLine)
                // Giới thiệu
                setUpGeneralInfo(giftTransaction)

            } else {
                scrollView.isHidden = true
            }
        }).disposed(by: disposeBag)

        viewModel.output.listProgress.subscribe(onNext: { [weak self] listProgress in
            guard let self = self else { return }
            statusCollectionView.reloadData()
        }).disposed(by: disposeBag)

        // Thông tin nhận hàng
        viewModel.output.shipInfo.subscribe(onNext: { [weak self] shipInfo in
            guard let self = self else { return }
            setUpShippingInfo(shipInfo)
        }).disposed(by: disposeBag)

        // Địa chỉ nhận hàng
        viewModel.output.fullLocation.subscribe(onNext: { [weak self] fullLocation in
            guard let self = self else { return }
            if let location = fullLocation, !location.isEmpty {
                shipLocationStackView.isHidden = false
                shipLocationLabel.text = location
            } else {
                shipLocationStackView.isHidden = true
            }
        }).disposed(by: disposeBag)

    }

    func setUpHeaderInfo(_ giftTransaction: GiftTransaction, _ imageLinks: [ImageLinkModel]?) {
        let isScrollImageEnable: Bool = imageLinks?.count ?? 0 > 1
        indexCarouselView.isHidden = !isScrollImageEnable
        carousel.isScrollEnabled = isScrollImageEnable
        carousel.reloadData()
        giftNameLabel.text = giftTransaction.giftName
        if let quantity = giftTransaction.quantity, quantity > 1 {
            quantityLabel.text = "Số lượng: \(quantity)"
            quantityLabel.isHidden = false
        } else {
            quantityLabel.isHidden = true
        }
    }

    func setUpProgressTransaction(_ giftTransaction: GiftTransaction) {
        if let rejectReason = giftTransaction.rejectReason, !rejectReason.isEmpty {
            cancelReasonContainerView.isHidden = false
            reasonLabel.text = rejectReason
        } else {
            cancelReasonContainerView.isHidden = true
        }
    }

    func setUpShippingInfo(_ shipInfo: PhysicalRewardShipModel?) {
        if let shipInfo = viewModel.output.shipInfo.value {
            shipInfoContainerView.isHidden = false
            if let name = shipInfo.fullName, !name.isEmpty {
                shipNameLabel.text = name
                shipNameLabel.isHidden = false
            } else {
                shipNameLabel.isHidden = true
            }
            if let phone = shipInfo.phoneNumber {
                shipPhoneStackView.isHidden = false
                shipPhoneLabel.text = phone
            } else {
                shipPhoneStackView.isHidden = true
            }
            if let note = shipInfo.note, !note.isEmpty {
                shipNoteLabel.text = note
                shipNoteStackView.isHidden = false
            } else {
                shipNoteStackView.isHidden = true
            }
        } else {
            shipInfoContainerView.isHidden = true
        }
    }

    // Thông tin khác
    func setUpOtherInfo(_ giftTransaction: GiftTransaction, _ hotline: String?) {
        let exchangeDateFormatter = UtilHelper.formatDate(date: giftTransaction.date, toFormatter: .ddMMyyyy)
        if !exchangeDateFormatter.isEmpty {
            exchangeDateStackView.isHidden = false
            exchangeDateLabel.text = exchangeDateFormatter
        } else {
            exchangeDateStackView.isHidden = true
        }
        if let hotline = hotline, !hotline.isEmpty {
            hotlineVendorStackView.isHidden = false
            hotlineVendorButton.setTitle(hotline, for: .normal)
        } else {
            hotlineVendorStackView.isHidden = true
        }
        otherInfoContainerView.isHidden = exchangeDateStackView.isHidden && hotlineVendorStackView.isHidden
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
            instructionWebView.getWebView(withHTMLContent: introduce, withStyle: .webViewDetail)
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

// MARK: -Actions
    @IBAction func onBackPressed(_ sender: Any) {
        self.pop()
    }

    @IBAction func openEmailAction(_ sender: Any) {
        if let email = viewModel.output.giftInfo.value?.giftTransaction?.contactEmail {
            UtilHelper.openEmail(email: email)
        }
    }

    @IBAction func callHotlineAction(_ sender: Any) {
        // Số điện thoại của LynkiD
        if let hotLine = viewModel.output.giftInfo.value?.giftTransaction?.contactHotline {
            UtilHelper.openPhoneCall(number: hotLine)
        }
    }

    @IBAction func callHotLineSupportAction(_ sender: Any) {
        // Số điện thoại vendor
        if let hotLine = viewModel.output.giftInfo.value?.vendorInfo?.hotLine {
            UtilHelper.openPhoneCall(number: hotLine)
        }
    }
}

extension PhysicalRewardDetailViewController: WKNavigationDelegate {

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

extension PhysicalRewardDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.listProgress.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: PhysicalRewardStatusCollectionViewCell.self, for: indexPath)
        let list = viewModel.output.listProgress.value
        let index = indexPath.row
        cell.setCellForData(isFistItem: index == 0, isLastItem: index == list.count - 1, data: list[index], index: index)
        return cell
    }

    // MARK: - Flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(viewModel.output.listProgress.value.count)
        let width = collectionView.frame.width / count
        return CGSize(width: width, height: 100.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension PhysicalRewardDetailViewController: iCarouselDataSource, iCarouselDelegate {

    // MARK: - iCarousel Datasource

    func numberOfItems(in carousel: iCarousel) -> Int {
        let count = viewModel.output.giftInfo.value?.imageLinks?.count ?? 0
        carouselPlaceholderImageView.isHidden = count > 0
        return count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView: UIImageView

        if view != nil {
            imageView = view as! UIImageView
        } else {
            imageView = UIImageView(frame: self.carousel.frame)
        }
        let imageLinks = viewModel.output.giftInfo.value?.imageLinks ?? []

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
        self.indexCarouselLabel.text = "\(carousel.currentItemIndex + 1)/\(viewModel.output.giftInfo.value?.imageLinks?.count ?? 0)"
    }
}

extension PhysicalRewardDetailViewController: UIScrollViewDelegate {
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

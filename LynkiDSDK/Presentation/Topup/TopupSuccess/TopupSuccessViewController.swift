//
//  TopupSuccessViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/08/2024.
//

import UIKit
import SwiftyAttributes

class TopupSuccessViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: TopupSuccessViewModel) -> Self {
        let vc = UIStoryboard.topup.instantiateViewController(ofType: TopupSuccessViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var ticketView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var giftTicketView: UIView!
    @IBOutlet weak var lcExtraInfoBottomToItemDescTop: NSLayoutConstraint!
    @IBOutlet weak var lcItemDescTopToSuperViewTop: NSLayoutConstraint!
    @IBOutlet weak var lcExtraInfoWidth: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var expiredDateLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityContainerView: UIView!
    @IBOutlet weak var installAppView: InstallAppBannerSmallView!
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var receiptView: UIView!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!


    var viewModel: TopupSuccessViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            ticketView.drawTicket(
                directionHorizontal: false,
                withCutoutRadius: 10,
                andCornerRadius: 12,
                fillColor: UIColor.white,
                andFrame: CGRect(x: 0, y: 0, width: ticketView.frame.size.width, height: ticketView.frame.size.height),
                andTicketPosition: CGPoint(x: ticketView.frame.size.width, y: viewModel.caculateTicketPosition()))

            // Gift item
            giftTicketView.drawTicket(
                directionHorizontal: true,
                withCutoutRadius: 8,
                andCornerRadius: 12,
                fillColor: nil,
                andFrame: CGRect(x: 0, y: 0, width: self.giftTicketView.frame.size.width, height: self.giftTicketView.frame.size.height),
                andTicketPosition: CGPointMake(80, self.giftTicketView.frame.size.height))


            useButton.setCommonGradient()

            quantityContainerView.setCommonGradient()
            quantityContainerView.layer.masksToBounds = true
            quantityContainerView.layer.cornerRadius = 8.0
            quantityContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        installAppView.configureUI()
    }

    override func initView() {
        titleLabel.text = viewModel.data.title
        let totalAmount = Double(viewModel.data.quantity) * (viewModel.data.giftInfo.giftInfor?.requiredCoin ?? 0)
        totalAmountLabel.text = "-\(totalAmount.formatter())"
        setUpGiftItem()
        receiptView.isHidden = viewModel.data.topupPhoneType != .postPaid
        configContactLabel()
    }

    func configContactLabel() {
        let attribute1 = "Để xuất hóa đơn vui lòng ".withAttributes([
                .textColor(.c261F28!),
                .font(.f14r!)
            ])
        let attribute2 = "Liên hệ CSKH.".withAttributes([
                .textColor(.mainColor!),
                .font(.f14s!)
            ])
        contactLabel.attributedText = attribute1 + attribute2
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        contactLabel.addGestureRecognizer(tapGesture)
        contactLabel.isUserInteractionEnabled = true
    }

    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = contactLabel.text else { return }
        let explore = (text as NSString).range(of: "Liên hệ CSKH.")
        if gesture.didTapAttributedTextInLabel(label: self.contactLabel, inRange: explore) {
            UtilHelper.callLynkiDHotLine()
        }
    }

    func setUpGiftItem() {
        imageView.setSDImage(with: viewModel.data.giftInfo.giftInfor?.brandLinkLogo, scaleMode: .scaleAspectFit)
        let brandName = viewModel.data.giftInfo.giftInfor?.brandName ?? ""
        vendorLabel.text = (!brandName.isEmpty ? brandName : "Thương hiệu khác").uppercased()
        giftNameLabel.text = viewModel.data.giftInfo.giftInfor?.name
        let expiredDateFormatter = UtilHelper.formatDate(date: viewModel.data.transactionInfo.eGift?.expiredDate, toFormatter: .ddMMyyyy)
        expiredDateLabel.text = "HSD: \(expiredDateFormatter)"
        expiredDateLabel.isHidden = expiredDateFormatter.isEmpty
        let quantity = viewModel.data.quantity
        if quantity > 1 {
            lcExtraInfoBottomToItemDescTop.priority = .defaultHigh
            lcItemDescTopToSuperViewTop.priority = .defaultLow
            lcExtraInfoWidth.constant = 40
            quantityLabel.text = "X\(quantity)"
            quantityContainerView.isHidden = false
        } else {
            lcExtraInfoBottomToItemDescTop.priority = .defaultLow
            lcItemDescTopToSuperViewTop.priority = .defaultHigh
            quantityContainerView.isHidden = true
        }
        useLabel.isHidden = !(viewModel.data.topupPhoneType == .buyCard || viewModel.data.topupDataType == .buyCard)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
    }

    override func setImage() {
        successImageView.image = .imageExchangeGiftSuccess
    }

    // MARK: - Action

    @IBAction func backToHome(_ sender: Any) {
        backToHomeScreen()
    }

    @IBAction func openTransactionDetail(_ sender: Any) {
        self.navigator.show(segue: .transactionDetail(orderCode: viewModel.data.transactionInfo.code ?? "")) { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func useGiftAction(_ sender: Any) {
        if let viewController = self.navigationController?.viewControllers.first(where: { $0 is TopupViewController }) {
            self.navigationController?.popToViewController(viewController, animated: true)
        }
    }

}

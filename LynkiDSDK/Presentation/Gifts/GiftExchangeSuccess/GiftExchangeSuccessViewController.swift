//
//  GiftExchangeSuccessViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/06/2024.
//

import Foundation
import UIKit

class GiftExchangeSuccessViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: GiftExchangeSuccessViewModel) -> Self {
        let vc = UIStoryboard.giftExchange.instantiateViewController(ofType: GiftExchangeSuccessViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var ticketView: UIView!

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

    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var successImageView: UIImageView!


    var viewModel: GiftExchangeSuccessViewModel!

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
        setUpGiftItem()
        if viewModel.isEgift {
            sendButton.isHidden = false
            useButton.setTitle("Dùng ngay", for: .normal)
        } else {
            useButton.setTitle("Theo dõi đơn hàng", for: .normal)
            sendButton.isHidden = true
        }
    }

    func setUpGiftItem() {
        imageView.setSDImage(with: viewModel.giftInfo.giftInfor?.brandLinkLogo, placeholderImage: .iconLogoDefault)
        let brandName = viewModel.giftInfo.giftInfor?.brandName ?? ""
        vendorLabel.text = (!brandName.isEmpty ? brandName : "Thương hiệu khác").uppercased()
        giftNameLabel.text = viewModel.giftInfo.giftInfor?.name
        let expiredDateFormatter = UtilHelper.formatDate(date: viewModel.transactionInfo.eGift?.expiredDate, toFormatter: .ddMMyyyy)
        if (!expiredDateFormatter.isEmpty) {
            expiredDateLabel.text = "HSD: \(expiredDateFormatter)"
            expiredDateLabel.isHidden = false
        } else {
            expiredDateLabel.isHidden = true
        }
        let quantity = viewModel.quantity
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
        self.navigator.show(segue: .transactionDetail(orderCode: viewModel.transactionInfo.code ?? "")) { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func sendGiftAction(_ sender: Any) {
        UtilHelper.showInstallAppPopup(parentVC: self)
    }

    @IBAction func useGiftAction(_ sender: Any) {
        let transactionCode = viewModel.transactionInfo.code ?? ""
        if viewModel.isEgift {
            self.navigator.show(segue: .egiftRewardDetail(giftInfo: viewModel.giftInfo, giftTransactionCode: transactionCode)) { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.navigator.show(segue: .physicalRewardDetail(giftInfo: viewModel.giftInfo, giftTransactionCode: transactionCode)) { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}

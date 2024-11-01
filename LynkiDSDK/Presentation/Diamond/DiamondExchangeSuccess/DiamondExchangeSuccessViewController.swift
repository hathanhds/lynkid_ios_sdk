//
//  GiftExchangeSuccessViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/06/2024.
//

import Foundation
import UIKit

class DiamondExchangeSuccessViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: DiamondExchangeSuccessViewModel) -> Self {
        let vc = UIStoryboard.diamond.instantiateViewController(ofType: DiamondExchangeSuccessViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var installAppView: InstallAppBannerSmallView!

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

    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backToHomeButton: UIButton!
    @IBOutlet weak var vpbankHotlineLabel: UILabel!
    @IBOutlet weak var vpbankDiamondHotlineLabel: UILabel!

    @IBOutlet weak var successImageView: UIImageView!
    var viewModel: DiamondExchangeSuccessViewModel!

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
                fillColor: .diamondBgColor,
                withStrokeColor: .clear,
                andFrame: CGRect(x: 0, y: 0, width: ticketView.frame.size.width, height: ticketView.frame.size.height),
                andTicketPosition: CGPoint(x: ticketView.frame.size.width, y: viewModel.caculateTicketPosition()))

            // Gift item
            giftTicketView.drawTicket(
                directionHorizontal: true,
                withCutoutRadius: 8,
                andCornerRadius: 12,
                fillColor: nil,
                withStrokeColor: .c37363A,
                andFrame: CGRect(x: 0, y: 0, width: self.giftTicketView.frame.size.width, height: self.giftTicketView.frame.size.height),
                andTicketPosition: CGPointMake(80, self.giftTicketView.frame.size.height))


            view.setDiamondBackgroundGradient()
            useButton.setDiamondButtonGradient()

            quantityContainerView.setDiamondButtonGradient()
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

        sendButton.isHidden = false

        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(vpbankTappedOnLabel(_:)))
        tapGesture1.numberOfTouchesRequired = 1
        vpbankHotlineLabel.addGestureRecognizer(tapGesture1)
        vpbankHotlineLabel.isUserInteractionEnabled = true
        vpbankHotlineLabel.text = Constant.vpbankHotline


        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(vpbankDiamondTappedOnLabel(_:)))
        tapGesture2.numberOfTouchesRequired = 1
        vpbankDiamondHotlineLabel.addGestureRecognizer(tapGesture2)
        vpbankDiamondHotlineLabel.isUserInteractionEnabled = true
        vpbankDiamondHotlineLabel.text = Constant.vpbankDiamondHotline
    }

    @objc func vpbankTappedOnLabel(_ gesture: UITapGestureRecognizer) {
        UtilHelper.callVpBankHotLine()
    }

    @objc func vpbankDiamondTappedOnLabel(_ gesture: UITapGestureRecognizer) {
        UtilHelper.callVpBankDiamondHotLine()
    }

    func setUpGiftItem() {
        imageView.setSDImage(with: viewModel.giftInfo.giftInfor?.brandLinkLogo, placeholderImage: .iconLogoDefault)
        let brandName = viewModel.giftInfo.giftInfor?.brandName ?? ""
        vendorLabel.text = (!brandName.isEmpty ? brandName : "Thương hiệu khác").uppercased()
        giftNameLabel.text = viewModel.giftInfo.giftInfor?.name
        let expiredString = UtilHelper.formatDate(date: viewModel.transactionInfo.eGift?.expiredDate, toFormatter: .ddMMyyyy)
        if !expiredString.isEmpty {
            expiredDateLabel.text = "HSD: \(expiredString)"
            expiredDateLabel.isHidden = false
        } else {
            expiredDateLabel.isHidden = false
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

    override func setImage() {
        backToHomeButton.setImage(with: .iconHomeWhite)
        successImageView.image = .imageExchangeGiftSuccess
        imageView.image = .iconLogoDefault
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
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
        UtilHelper.showInstallAppPopup(parentVC: self, isVpbankDiamond: true)
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

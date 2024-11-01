//
//  AccountExistAndConnectedViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import UIKit
import RxSwift
import SwiftyAttributes

// Tồn tại tài khoản X từ App chủ
// SĐT X đã liên kết LID

class AccountExistAndConnectedViewController: BaseViewController, ViewControllerType {
    typealias ViewModel = AccountExistAndConnectedViewModel

    static func create(with navigator: Navigator, viewModel: AccountExistAndConnectedViewModel) -> Self {
        let vc = UIStoryboard.auth.instantiateViewController(ofType: AccountExistAndConnectedViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var logoLinkIdImageView: UIImageView!
    @IBOutlet weak var logoMerchantImageView: UIImageView!


    // Variables
    var viewModel: AccountExistAndConnectedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        acceptButton.setCommonGradient()
        view.setCommonGradient()
    }

    override func setImage() {
        logoMerchantImageView.image = .imageMerchantDefault
        logoLinkIdImageView.image = .iconAppPlaceholder
    }

    override func initView() {
        let fontRegular: UIFont = .f14r!

        let attribute1 = "Số điện thoại ".withAttributes([
                .textColor(.c6D6B7A!),
                .font(fontRegular)
            ])
        let attribute2 = " có phải là số điện thoại của bạn".withAttributes([
                .textColor(.c6D6B7A!),
                .font(fontRegular)
            ])

        let attachment = NSTextAttachment()
        attachment.image = pgImage(textValue: AppConfig.shared.phoneNumberFormatter)
        attachment.bounds = CGRect(x: 0, y: -6, width: (attachment.image?.size.width)!, height: (attachment.image?.size.height)!)
        attribute1.append(NSAttributedString(attachment: attachment))
        let attributedString = attribute1 + attribute2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        paragraphStyle.alignment = .center

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        titleLabel.attributedText = attributedString
    }

    @IBAction func acceptAction(_ sender: Any) {
        AppConfig.shared.viewMode = .authenticated
        self.navigator.show(segue: .main) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true) {
                self.showToast(ofType: .success, withMessage: "Đồng bộ tài khoản thành công")
            }

        }
    }

    @IBAction func skipAction(_ sender: Any) {
        AppConfig.shared.viewMode = .anonymous
        self.navigator.show(segue: .main) { [weak self] vc in
            guard let self = self else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dimissAllViewControllers()
    }
}

extension AccountExistAndConnectedViewController {
    func pgImage(textValue: String) -> UIImage {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        label.textAlignment = .center
        label.textColor = UIColor.mainColor
        label.font = .f14s
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.cornerRadius = 4
        label.layer.backgroundColor = UIColor.cF1EBF6?.cgColor
        label.text = textValue
        label.sizeToFit()
        label.bounds = CGRect(x: 0, y: 0, width: label.bounds.size.width + 10, height: label.bounds.size.height + 4)

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, UIScreen.main.scale)
        label.layer.allowsEdgeAntialiasing = true
        label.layer.render(in: UIGraphicsGetCurrentContext()!)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



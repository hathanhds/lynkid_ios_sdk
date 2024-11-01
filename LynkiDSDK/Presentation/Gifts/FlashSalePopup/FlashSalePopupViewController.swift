//
//  FlashSalePopUpViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/07/2024.
//

import Foundation
import UIKit

class FlashSalePopupViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: FlashSalePopupViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: FlashSalePopupViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // IBOutlets
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var installAppButton: UIButton!

    // Variables
    var viewModel: FlashSalePopupViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonClose.setImage(with: .iconClose)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        installAppButton.setInstallAppButtonGradient()
        view.setCommonGradient()
    }

    // MARK: -Action
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func buyWithOriginalPriceAction(_ sender: Any) {
        self.dismiss(animated: true)
        FlashSale.shared.stopFlashSale()
    }

    @IBAction func installAppAction(_ sender: Any) {
        UtilHelper.openLynkiDAPP()
    }

}

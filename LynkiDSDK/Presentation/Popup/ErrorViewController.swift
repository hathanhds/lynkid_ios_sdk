//
//  ErrorViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/03/2024.
//

import Foundation
import UIKit

class DiamondExchangeErrorViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: DiamondExchangeErrorViewModel) -> DiamondExchangeErrorViewController {
        let vc = UIStoryboard.popup.instantiateViewController(ofType: DiamondExchangeErrorViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc
    }

    // Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var vpbankHotlineLabel: UILabel!
    @IBOutlet weak var vpbankDiamondLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    var viewModel: DiamondExchangeErrorViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.acceptAction))
        bgView.addGestureRecognizer(gesture)
    }

    override func initView() {
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(vpbankTappedOnLabel(_:)))
        tapGesture1.numberOfTouchesRequired = 1
        vpbankHotlineLabel.addGestureRecognizer(tapGesture1)
        vpbankHotlineLabel.isUserInteractionEnabled = true
        vpbankHotlineLabel.text = Constant.vpbankHotline


        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(vpbankDiamondTappedOnLabel(_:)))
        tapGesture2.numberOfTouchesRequired = 1
        vpbankDiamondLabel.addGestureRecognizer(tapGesture2)
        vpbankDiamondLabel.isUserInteractionEnabled = true
        vpbankDiamondLabel.text = Constant.vpbankDiamondHotline
    }

    override func setImage() {
        closeButton.setImage(with: .iconCloseYellow)
    }

    @objc func vpbankTappedOnLabel(_ gesture: UITapGestureRecognizer) {
        UtilHelper.callVpBankHotLine()
    }

    @objc func vpbankDiamondTappedOnLabel(_ gesture: UITapGestureRecognizer) {
        UtilHelper.callVpBankDiamondHotLine()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }


    @IBAction func acceptAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

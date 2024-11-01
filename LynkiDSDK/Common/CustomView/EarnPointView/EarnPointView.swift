//
//  EarnPointView.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/08/2024.
//

import UIKit
import SwiftyAttributes

class EarnPointView: UIView, NibLoadable {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var fromVC = BaseViewController()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    func initView(fromVC: BaseViewController) {
        self.fromVC = fromVC
    }
    
    var earnMoreCoin: Double = 0 {
        didSet {
            configUI()
        }
    }
    
    func configUI() {
        let attribute1 = "Tích thêm \(earnMoreCoin.formatter()) điểm nữa để đổi ưu đãi nhé.".withAttributes([
                .textColor(.c261F28!),
                .font(.f14r!)
            ])
        let attribute2 = " Khám phá ngay".withAttributes([
                .textColor(.mainColor!),
                .font(.f14s!)
            ])
        titleLabel.attributedText = attribute1 + attribute2
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        titleLabel.addGestureRecognizer(tapGesture)
        titleLabel.isUserInteractionEnabled = true
    }

    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = titleLabel.text else { return }
        let explore = (text as NSString).range(of: "Khám phá ngay")
        if gesture.didTapAttributedTextInLabel(label: self.titleLabel, inRange: explore) {
            UtilHelper.showInstallAppPopup(parentVC: self.fromVC)
        }
    }

}

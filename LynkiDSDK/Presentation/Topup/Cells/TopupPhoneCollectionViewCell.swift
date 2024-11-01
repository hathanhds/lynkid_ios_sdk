//
//  TopupPhoneCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/08/2024.
//

import UIKit

class TopupPhoneCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardPriceLabel: UILabel!
    @IBOutlet weak var coinContainerView: UIView!
    @IBOutlet weak var cashBackLabel: UILabel!
    @IBOutlet weak var requiredCoinLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        fullPriceLabel.strikeThrough()
        checkBoxImageView.image = .iconCheckBoxFilter
    }

    func setDataForCell(gift: GiftInfoItem, isSelected: Bool = false) {
        if (isSelected) {
            containerView.borderColor = .mainColor
            containerView.borderWidth = 1
            checkBoxImageView.isHidden = false
        } else {
            containerView.borderWidth = 0
            checkBoxImageView.isHidden = true
        }
        let fullPrice = gift.giftInfor?.fullPrice ?? 0
        let requiredCoin = gift.giftInfor?.requiredCoin ?? 0

        let cashBack: Double = (Double(gift.giftInfor?.commisPercentCategory ?? 0) * fullPrice / 100)
        cardPriceLabel.text = "\(fullPrice.formatter())đ"
        if (fullPrice > 0 && requiredCoin < fullPrice) {
            fullPriceLabel.text = fullPrice.formatter()
            coinContainerView.isHidden = false
        } else {
            coinContainerView.isHidden = true
        }
        requiredCoinLabel.text = requiredCoin.formatter()
        if (cashBack > 0) {
            cashBackLabel.text = "Hoàn \(cashBack.formatter()) điểm"
            cashBackLabel.isHidden = false
        } else {
            cashBackLabel.isHidden = true
        }
    }
}

//
//  TopupDataCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/08/2024.
//

import UIKit

class TopupDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dataSizeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var requiredCoinLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!
    @IBOutlet weak var checkBoxFilterImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        fullPriceLabel.strikeThrough()
        checkBoxFilterImageView.image = .iconCheckBoxFilter
    }

    func setDataForCell(gift: GiftInfoItem, isSelected: Bool = false) {
        if (isSelected) {
            containerView.borderColor = .mainColor
            containerView.borderWidth = 1
            checkBoxFilterImageView.isHidden = false
        } else {
            containerView.borderWidth = 0
            checkBoxFilterImageView.isHidden = true
        }
        let giftInfor = gift.giftInfor
        let fullPrice = giftInfor?.fullPrice ?? 0
        let requiredCoin = giftInfor?.requiredCoin ?? 0
        let dataSize = giftInfor?.name?.split(separator: "/").map{String($0)}.first
        var duration = ""
        if (giftInfor?.name?.contains("/") ?? false) {
            duration = "1 ngày"
        } else {
            // TODO: trimleft
            duration = (giftInfor?.description?.split(separator: ":").map{String($0)}.last ?? "").trim()
        }
        dataSizeLabel.text = dataSize
        timeLabel.text = duration
        requiredCoinLabel.text = requiredCoin.formatter()
        if (requiredCoin < fullPrice) {
            fullPriceLabel.text = fullPrice.formatter()
            fullPriceLabel.isHidden = false
        } else {
            fullPriceLabel.isHidden = true
        }
    }

}

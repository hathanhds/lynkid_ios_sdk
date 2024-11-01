//
//  DiamondGiftCollectionViewCell.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 24/06/2024.
//

import UIKit

class DiamondGiftCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var discountPercentButton: UIButton!
    @IBOutlet weak var fullPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.masksToBounds = true
        thumbImageView.layer.cornerRadius = 12
        thumbImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        contentContainerView.backgroundColor = .c332D2E
        contentContainerView.layer.masksToBounds = true
        contentContainerView.layer.cornerRadius = 12

        discountPercentButton.layer.cornerRadius = 12
        discountPercentButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        discountPercentButton.layer.masksToBounds = true
        
        fullPriceLabel.strikeThrough()
    }

    func setDataForCell(data: GiftInfor?, imageLink: String?) {
        thumbImageView.setSDImage(with: imageLink ?? "")
        if let brandName = data?.brandName, !brandName.isEmpty {
            brandLabel.text = data?.brandName?.uppercased()
            brandLabel.isHidden = false
        } else {
            brandLabel.isHidden = true
        }
        titleLabel.text = data?.name
        titleLabel.numberOfLines = 2
        priceLabel.text = data?.requiredCoin?.formatter()
        if let fullPrice = data?.fullPrice, fullPrice > data?.requiredCoin ?? 0 {
            fullPriceLabel.isHidden = false
            fullPriceLabel.text = data?.fullPrice?.formatter()
        } else {
            fullPriceLabel.isHidden = true
        }
        if let discountPrice = data?.discountPrice, discountPrice > 0 {
            discountPercentButton.isHidden = false
            discountPercentButton.setTitle("-\(Int(discountPrice))%", for: .normal)
        } else {
            discountPercentButton.isHidden = true
        }
    }
}

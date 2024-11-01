//
//  GiftCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import UIKit

class GiftCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setDataForCell(gift: GiftByGroupItem) {
        titleLabel.text = gift.giftInfo?.name
        titleLabel.numberOfLines = 2
        imageView.setSDImage(with: gift.fullLink, placeholderImage: .imgLinkIDPlaceholder)
        priceLabel.text = gift.giftInfo?.requiredCoin?.formatter()
    }

}

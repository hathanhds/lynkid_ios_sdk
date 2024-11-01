//
//  GiftFilterPriceCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 06/03/2024.
//

import UIKit

class GiftFilterPriceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var priceTitleLabel: UILabel!



    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func setDataForCell(data: RangeCoin, isSelected: Bool = false) {
        priceTitleLabel.text = data.displayText
        if (isSelected) {
            contentView.borderColor = .mainColor
            contentView.borderWidth = 1.0
        } else {
            contentView.borderWidth = 0
        }
    }

}

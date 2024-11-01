//
//  OptionItemCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 08/03/2024.
//

import UIKit

class OptionItemCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.isHidden = true
        imageView.image = .iconCheckBoxFilter
    }

    func setDataForCell(data: OptionModel, isSelected: Bool = false) {
        titleLabel.text = data.title
        if isSelected {
            containerView.borderColor = .mainColor
            containerView.borderWidth = 1.0
            imageView.isHidden = false
        } else {
            containerView.borderWidth = 0
            imageView.isHidden = true
        }
    }
}

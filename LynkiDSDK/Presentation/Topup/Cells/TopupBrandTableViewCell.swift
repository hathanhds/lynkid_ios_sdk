//
//  TopupBrandTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/08/2024.
//

import UIKit

class TopupBrandTableViewCell: UITableViewCell {

    @IBOutlet weak var brandContainerView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        brandContainerView.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setDataForCell(brandInfo: TopupBrandItem, isSelected: Bool = false, isLastItem: Bool = false) {
        if (isSelected) {
            checkBoxImageView.isHidden = false
            brandContainerView.borderWidth = 1.0
            brandContainerView.borderColor = .mainColor
            brandNameLabel.textColor = .mainColor
        } else {
            checkBoxImageView.isHidden = true
            brandContainerView.borderColor = .cEFEFF6
            brandNameLabel.textColor = .c242424
        }
        brandNameLabel.text = brandInfo.brandName
        brandImageView.setSDImage(with: brandInfo.linkLogo, scaleMode: .scaleAspectFit)
        separatorView.isHidden = isLastItem
    }

}

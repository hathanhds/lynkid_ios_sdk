//
//  MyRewardLocationTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/05/2024.
//

import UIKit

class GiftLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var copyImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDataForCell(data: GiftUsageLocationItem, isLastItem: Bool, isDiamond: Bool? = false) {
        if(isDiamond == true) {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = .clear
            containerView.backgroundColor = .clear
            nameLabel.textColor = .white
            addressLabel.textColor = .cA7A7B3
            locationImageView.image = .iconGiftLocationGray
            copyImageView.image = .iconCopyGray
            separatorView.backgroundColor = .c37363A
        } else {
            self.backgroundColor = .white
            self.contentView.backgroundColor = .white
            containerView.backgroundColor = .white
            nameLabel.textColor = .c242424
            addressLabel.textColor = .c242424
            locationImageView.image = .iconGiftLocationGray
            copyImageView.image = .iconCopyGray
        }

        nameLabel.text = data.name
        addressLabel.text = data.address
        separatorView.isHidden = isLastItem

    }
}

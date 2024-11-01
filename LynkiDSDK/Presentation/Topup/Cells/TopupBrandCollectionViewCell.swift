//
//  TopupBrandCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/08/2024.
//

import UIKit

class TopupBrandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBoxImageView.image = .iconCheckBoxFilter
        containerView.borderWidth = 1
    }
    
    func setDataForCell(brandInfo: TopupBrandItem, isSelected: Bool) {
        brandImageView.setSDImage(with: brandInfo.linkLogo, scaleMode: .scaleAspectFit)
        if (isSelected) {
            checkBoxImageView.isHidden = false
            containerView.borderColor = .mainColor
        } else {
            checkBoxImageView.isHidden = true
            containerView.borderColor = .cD8D6DD
        }
    }
    
    
    
}

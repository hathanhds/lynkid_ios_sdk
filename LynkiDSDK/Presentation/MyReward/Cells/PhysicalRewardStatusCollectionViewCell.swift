//
//  PhysicalRewardStatusCollectionViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/05/2024.
//

import UIKit

class PhysicalRewardStatusCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var rightLineView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var stepLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.setCommonGradient()
    }


    func setCellForData(isFistItem: Bool, isLastItem: Bool, data: PhysicalRewardTransactionModel, index: Int) {
        statusView.setCommonGradient()
        if (isFistItem) {
            leftLineView.layer.masksToBounds = false
            leftLineView.layer.cornerRadius = 2
            leftLineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
        if isLastItem {
            rightLineView.layer.masksToBounds = false
            rightLineView.layer.cornerRadius = 2
            rightLineView.layer.maskedCorners = [.layerMaxXMinYCorner, . layerMaxXMaxYCorner]
        }

        if (data.isLeftLineActive) {
            leftLineView.backgroundColor = .mainColor
            dotView.backgroundColor = .mainColor
            statusLabel.textColor = .mainColor
            statusView.isHidden = false
            stepView.isHidden = true
        } else {
            leftLineView.backgroundColor = .cD8D6DD
            dotView.backgroundColor = .cD8D6DD
            statusLabel.textColor = .cA7A7B3
            statusView.isHidden = true
            stepView.isHidden = false
        }
        rightLineView.backgroundColor = data.isRightLineActive ? .mainColor : .cD8D6DD
        statusLabel.text = data.title
        stepLabel.text = "\(index + 1)"
    }

}

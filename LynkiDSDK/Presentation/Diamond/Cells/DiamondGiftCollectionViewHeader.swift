//
//  DiamondGiftCollectionViewHeader.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 28/06/2024.
//

import UIKit

class DiamondGiftCollectionViewHeader: UICollectionReusableView{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    // Add any views or initialization code here
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
        
    func setDataForCell(data: GiftCategory) {
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        titleLabel.text = data.descTitle
        descLabel.text = data.descContent
    }
        
}

//
//  TransactionDetailHelpCenterTableViewCell.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 11/06/2024.
//

import UIKit

class TransactionDetailHelpCenterTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
    }
}

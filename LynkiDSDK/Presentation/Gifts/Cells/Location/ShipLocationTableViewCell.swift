//
//  ShipLocationTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 26/06/2024.
//

import UIKit

class ShipLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setDataForCell(location: LocationModel, isLastItem: Bool) {
        titleLabel.text = location.name
        separatorView.isHidden = isLastItem
    }

}

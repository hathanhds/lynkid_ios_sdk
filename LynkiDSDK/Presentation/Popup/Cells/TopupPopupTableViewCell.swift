//
//  TopupPopupTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/08/2024.
//

import UIKit

class TopupPopupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataForCell(data: TopupPopupModel, isLastItem: Bool) {
        titleLabel.text = data.title
        detailLabel.text = data.detail
        lineView.isHidden = isLastItem
    }

}

struct TopupPopupModel {
    let title: String
    let detail: String
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
}


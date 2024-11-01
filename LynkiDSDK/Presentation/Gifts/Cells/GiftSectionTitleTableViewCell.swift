//
//  GiftSectionTitleTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/02/2024.
//

import UIKit

class GiftSectionTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDataForCell(isShowSearchResult: Bool? = nil, title: String) {
        if let isShowSearchResult = isShowSearchResult, isShowSearchResult {
            titleLabel.font = .systemFont(ofSize: 14)
        }
        titleLabel.text = title
    }

}

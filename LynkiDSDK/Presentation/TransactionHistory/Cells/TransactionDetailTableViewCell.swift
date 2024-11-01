//
//  TransactionDetailTableViewCell.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 11/06/2024.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var imgViewBrandLogo: UIImageView!
    @IBOutlet weak var lcImgViewCopyWidth: NSLayoutConstraint!
    @IBOutlet weak var lcLogoBrandHeight: NSLayoutConstraint!

    var copyCodeAction: ((String) -> Void)?
    var data: TransactionDetailCustomModel?

    override func awakeFromNib() {
        super.awakeFromNib()

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setLastCell(isLastCell: Bool) {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = isLastCell ? 12 : 0
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func setDataForCell(item: TransactionDetailCustomModel) {
        data = item
        lbTitle.text = item.leftText
        if(item.isDate) {

            var date = ""
            if (item.leftText == "Sử dụng đến ngày") {
                date = Date.init(fromString: item.rightText, formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy) ?? ""
            } else {
                date = Date.init(fromString: item.rightText, formatter: .yyyyMMddThhmmss)?.toString(formatter: .HHmm_ddMMYYYY) ?? ""
            }
            lbContent.text = "\(date)"
        } else {
            lbContent.text = item.rightText.count > 12 && item.id == 1 ? "\(String(describing: item.rightText.prefix(6)))...\(String(describing: item.rightText.suffix(6)))" : item.rightText
        }

        if item.logo.count > 0 {
            lcLogoBrandHeight.constant = 24
            imgViewBrandLogo.setSDImage(with: item.logo, placeholderImage: .iconAppPlaceholder)
        } else {
            lcLogoBrandHeight.constant = 0
        }

        if item.id == 1 {

            lcImgViewCopyWidth.constant = 16
        } else {
            lcImgViewCopyWidth.constant = 0
        }
    }

    @IBAction func btnCopyClick(_ sender: Any) {
        copyCodeAction?(data?.rightText ?? "")
    }

}

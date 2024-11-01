//
//  TransactionItemTableViewCell.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 03/06/2024.
//

import UIKit

class TransactionItemTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var lcContainerViewTopToSuperviewTop: NSLayoutConstraint!
    @IBOutlet weak var lcContainerViewTopToTitleLabelBottom: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        brandImageView.layer.cornerRadius = brandImageView.frame.height / 2
        brandImageView.layer.masksToBounds = true
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setLastCell(isLastCell: Bool) {
        titleLabel.text = isLastCell ? "Giao dịch liên quan" : ""
        lcContainerViewTopToSuperviewTop.priority = isLastCell ? .defaultLow : .defaultHigh
        lcContainerViewTopToTitleLabelBottom.priority = isLastCell ? .defaultHigh : .defaultLow
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = isLastCell ? 12 : 0
    }

    func setDataForTransactionDetail(item: TransactionDetailModel) {
        if let data = UserDefaults.standard.data(forKey: Constant.kAllMerchant) {
            if let model = try? data.decoded(type: MerchantListResultModel.self) {

                brandImageView.image = .iconAppPlaceholder

                nameLabel.text = item.title ?? ""

                if let transactionTime = item.creationTime {
                    let date = Date.init(fromString: transactionTime, formatter: .yyyyMMddThhmmss)?.toString(formatter: .HHmm_ddMM) ?? ""
                    dateLabel.text = "\(date)"
                } else {
                    dateLabel.text = ""
                }

                let coinTextColor: UIColor = (item.walletAddress != nil && item.toWalletAddress != nil && item.walletAddress == item.toWalletAddress)
                    ? UIColor.c34C759!
                : UIColor.cF5574E!

                let sign = (item.walletAddress != nil && item.toWalletAddress != nil && item.walletAddress == item.toWalletAddress)
                    ? "+"
                : "-"

                let amount = item.amount ?? 0
                if amount > 0 {
                    coinLabel.text = "\(sign) \(item.amount!.formatter())"
                    coinLabel.textColor = coinTextColor
                } else {
                    coinLabel.text = "\(amount.formatter())"
                    coinLabel.textColor = .c242424
                }

            }
        }
    }

    func setDataForCell(item: TransactionItem) {
        lcContainerViewTopToSuperviewTop.priority = .defaultHigh
        lcContainerViewTopToTitleLabelBottom.priority = .defaultLow
        if let data = UserDefaults.standard.data(forKey: Constant.kAllMerchant) {
            if let model = try? data.decoded(type: MerchantListResultModel.self) {
                let transactionThumb = TransactionHistoryItemString.shared.handlePointHistoryImage(merchants: model.items, pointHistory: item, forceContent: "")
                if (transactionThumb!.isWebURL()) {
                    brandImageView.setSDImage(with: transactionThumb ?? "")
                } else {
                    brandImageView.image = UIImage(named: transactionThumb ?? "ic_app_placeholder", in: UIStoryboard.bundle, compatibleWith: nil)
                }

                nameLabel.text = TransactionHistoryItemString.shared.handlePointHistoryType(pointHistoryItem: item)

                if let transactionTime = item.time {
                    let date = Date.init(fromString: transactionTime, formatter: .yyyyMMddThhmmss)?.toString(formatter: .HHmm_ddMM) ?? ""
                    dateLabel.text = "\(date)"
                } else {
                    dateLabel.text = ""
                }

                let coinTextColor: UIColor = (item.userAddress != nil && item.toWalletAddress != nil && item.userAddress == item.toWalletAddress)
                    ? UIColor.c34C759!
                : UIColor.cF5574E!

                let sign = (item.userAddress != nil && item.toWalletAddress != nil && item.userAddress == item.toWalletAddress)
                    ? "+"
                : "-"

                let tokenAmount = item.tokenAmount ?? 0
                if tokenAmount > 0 {
                    coinLabel.text = "\(sign) \(tokenAmount.formatter())"
                    coinLabel.textColor = coinTextColor
                } else {
                    coinLabel.text = "\(tokenAmount.formatter())"
                    coinLabel.textColor = .c242424
                }
            }
        }
    }
}


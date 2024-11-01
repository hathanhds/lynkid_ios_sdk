//
//  MyRewardTableViewCell.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 01/04/2024.
//

import UIKit

class MyRewardTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ticketContainerView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var lcExtraInfoWidth: NSLayoutConstraint!
    @IBOutlet weak var lcExtraInfoBottomToItemDescTop: NSLayoutConstraint!
    @IBOutlet weak var lcItemDescTopToSuperViewTop: NSLayoutConstraint!
    @IBOutlet weak var lbExtraInfo: UILabel!
    @IBOutlet weak var vExtraInfo: UIView!
    @IBOutlet weak var useNowWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var useNowLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        brandImageView.layer.cornerRadius = 32
        brandImageView.layer.masksToBounds = true
        brandImageView.image = .iconLogoDefault
        // Initialization code


        vExtraInfo.layer.masksToBounds = true
        vExtraInfo.layer.cornerRadius = 8.0
        vExtraInfo.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        ticketContainerView.drawTicket(
            directionHorizontal: true,
            withCutoutRadius: 8,
            andCornerRadius: 12,
            fillColor: nil,
            andFrame: CGRect(x: 0, y: 0, width: self.ticketContainerView.frame.size.width, height: self.ticketContainerView.frame.size.height),
            andTicketPosition: CGPointMake(80, self.ticketContainerView.frame.size.height))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        DispatchQueue.main.async { [self] in
        // The layout pass is complete, frames should now be accurate

//        self.layoutIfNeeded()
//        self.setNeedsLayout()
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

    func setDataForTransactionDetail(data: TransactionDetailModel) {
        useNowLabel.isHidden = true
        nameLabel.text = data.giftName
        nameLabel.numberOfLines = 2
        if let brandTitle = data.brandName {
            brandLabel.text = brandTitle.uppercased()
        } else {
            brandLabel.text = "THƯƠNG HIỆU KHÁC"
        }
        brandImageView.setSDImage(with: data.brandImage ?? "", placeholderImage: .iconLogoDefault)
        if let redeemQuantity = data.redeemQuantity, redeemQuantity > 1 {
            lcExtraInfoBottomToItemDescTop.priority = .defaultHigh
            lcItemDescTopToSuperViewTop.priority = .defaultLow
            lcExtraInfoWidth.constant = 40
            lbExtraInfo.text = "x\(redeemQuantity)"
            vExtraInfo.isHidden = false
            vExtraInfo.setCommonGradient()
        } else {
            lcExtraInfoBottomToItemDescTop.priority = .defaultLow
            lcItemDescTopToSuperViewTop.priority = .defaultHigh
            vExtraInfo.isHidden = true
        }

        if let expiredDate = data.eGiftExpiredDate {
            if(expiredDate.isEmpty == false) {
                let date = Date.init(fromString: expiredDate, formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy) ?? ""
                dateLabel.text = "HSD: \(date)"
            } else {
                dateLabel.text = ""
            }
        } else {
            dateLabel.text = ""
        }
    }

    func setDataForCell(data: GiftInfoItem, isUsedGift: Bool = false, isLastItem: Bool = false) {
        brandImageView.setSDImage(with: data.brandInfo?.brandImage ?? "", placeholderImage: .iconLogoDefault)
        nameLabel.text = data.giftTransaction?.giftName

        if let brandTitle = data.brandInfo?.brandName {
            brandLabel.text = brandTitle.uppercased()
        } else {
            brandLabel.text = "THƯƠNG HIỆU KHÁC"
        }
        if (isUsedGift) {
            brandImageView.image = brandImageView.image?.applyColorFilter()
            useNowWidthConstraint.constant = 0
            dateLabel.text = displaydDateInfo(giftInfo: data)
            dateLabel.textColor = .cF5574E
        } else {
            if let expiredDate = data.eGift?.expiredDate ?? data.giftInfor?.expireDuration {
                let date = Date.init(fromString: expiredDate, formatter: .yyyyMMddThhmmss)?.toString(formatter: .ddMMyyyy) ?? ""
                dateLabel.text = "HSD: \(date)"
            } else {
                dateLabel.text = ""
            }
            useNowLabel.text = data.eGift != nil ? "DÙNG NGAY" : "THEO DÕI"
        }
        let whyhaveIt = data.giftTransaction?.whyHaveIt
        if let extraInfo = extraInfo(giftInfoItem: data) {
            lcExtraInfoBottomToItemDescTop.priority = .defaultHigh
            lcItemDescTopToSuperViewTop.priority = .defaultLow
            vExtraInfo.backgroundColor = extraInfo.color
            if (whyhaveIt == WhyHaveRewardType.received.rawValue) {
                vExtraInfo.backgroundColor = .mainColor
            }
            let path = UIBezierPath(roundedRect: vExtraInfo.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            vExtraInfo.layer.mask = mask
            lbExtraInfo.text = extraInfo.info
            vExtraInfo.isHidden = false
        } else {
            lcExtraInfoBottomToItemDescTop.priority = .defaultLow
            lcItemDescTopToSuperViewTop.priority = .defaultHigh
            vExtraInfo.isHidden = true
        }

        bottomContainerConstraint.constant = isLastItem ? 16.0 : 0
    }

    func extraInfo(giftInfoItem: GiftInfoItem) -> (info: String, color: UIColor?)? {
        let isEgift = giftInfoItem.eGift != nil
        let isShowReceiveReward = isEgift && (giftInfoItem.giftTransaction?.whyHaveIt ?? "") == WhyHaveRewardType.received.rawValue

        if isShowReceiveReward {
            return (info: "Quà tặng", color: UIColor.mainColor)
        } else if !isEgift {
            guard let status = giftInfoItem.giftTransaction?.status else {
                return nil
            }
            switch status {
            case "Pending", "Waiting":
                return (info: "Chờ xác nhận", color: UIColor.cFFAD33)
            case "Approved", "Confirmed":
                return (info: "Đã xác nhận", color: UIColor.c007AFF) // systemBlue
            case "Rejected", "Canceled":
                return (info: "Đã hủy", color: UIColor.cF5574E) // systemRed
            case "Delivered", "Delivering", "Returned", "Returning":
                return (info: status == "Delivering" ? "Đang giao" : (status == "Returned" ? "Đã trả hàng" : (status == "Returning" ? "Đang trả hàng" : "Đã giao hàng")), color: UIColor.c34C759) // systemGreen
            default:
                return nil
            }
        }
        return nil
    }

    func displaydDateInfo(giftInfo: GiftInfoItem?) -> String {
        let egift = giftInfo?.eGift
        let giftTransaction = giftInfo?.giftTransaction
        let expiredDate = UtilHelper.formatDate(date: egift?.expiredDate)
        let sentDate = UtilHelper.formatDate(date: giftTransaction?.transferTime)
        let usedDate = UtilHelper.formatDate(date: giftTransaction?.eGiftUsedAt)

        let whyHaveIt = giftTransaction?.whyHaveIt
        let usedStatus = egift?.usedStatus
        let isDiamondTrial = giftTransaction?.isExperienceGift ?? false
        if (whyHaveIt == WhyHaveRewardType.sent.rawValue && !sentDate.isEmpty) {
            return "Đã tặng vào \(sentDate)"
        } else if (usedStatus == EgiftRewardStatus.expired.rawValue && !expiredDate.isEmpty) {
            return "Hết hạn vào \(expiredDate)"
        } else if (usedStatus == EgiftRewardStatus.used.rawValue) {
            if(!usedDate.isEmpty) {
                return isDiamondTrial ? "Gửi yêu cầu vào \(usedDate)" : "Đã dùng vào \(usedDate)"
            } else {
                return "Đã sử dụng"
            }
        } else {
            return ""
        }
    }
}

extension MyRewardTableViewCell {
    func setDataForTopupTransaction(data: TopupTransactionItem, isLastItem: Bool = false) {
        brandImageView.setSDImage(with: data.brandInfo?.brandImage ?? "", placeholderImage: .iconLogoDefault, scaleMode: .scaleAspectFit)
        brandImageView.layer.cornerRadius = 0
        nameLabel.text = data.giftName

        if let brandTitle = data.brandInfo?.brandName {
            brandLabel.text = brandTitle.uppercased()
        } else {
            brandLabel.text = "THƯƠNG HIỆU KHÁC"
        }
        let whyHaveItType = data.whyHaveItType
        let eGiftStatusType = data.eGiftStatusType
        let statusType = data.statusType
        let isUsedGift = eGiftStatusType != .redeemed
        /// hiện HSD và Btn 'NẠP NGAY' khi
        /// thẻ chưa sử dụng (eGiftStatus == Redeemed)
        /// mua hoặc được tặng (whyHaveIt == BOUGHT || RECEIVED)
        /// và giao dịch mua thành công (status == 'Delivered)
        let isShowUseNowButton = eGiftStatusType == .redeemed && (whyHaveItType == .bought || whyHaveItType == .received) && statusType == .delivered
        useNowLabel.text = "NẠP NGAY"
        useNowLabel.isHidden = !isShowUseNowButton
        dateLabel.text = getDisplayTopupTransactionDate(data: data)
        if (isUsedGift) {
//            DispatchQueue.main.async {
//
//                self.brandImageView.image = self.brandImageView.image?.withRenderingMode(.alwaysOriginal)
//            }
            self.brandImageView.image = self.brandImageView.image?.applyColorFilter()

        }
        bottomContainerConstraint.constant = isLastItem ? 16.0 : 0
    }

    // Nếu remainingDay > 10 ngày => hiển thị ngày hết hạn
    // Nếu remainingDay >= 1 && remainingDay <=10 => hiển thị Hết hạn sau remainingDay
    // Nếu remainingHour > 0 && remainingHour <=24 => hiển thị hết hạn sau remainingHour
    func getDisplayTopupTransactionDate(data: TopupTransactionItem) -> String? {
        let eGiftExpiredDate = data.eGiftExpiredDate
        let currentDate = Date().toLocalTime()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatterType.yyyyMMddThhmmss.value
        let expiredDateString = UtilHelper.formatDate(date: eGiftExpiredDate, toFormatter: .ddMMyyyy)
        dateLabel.textColor = .cF5574E
        if let eGiftExpiredDate = dateFormatter.date(from: eGiftExpiredDate ?? ""), eGiftExpiredDate > currentDate {
            let diffStartCurrent = Int(eGiftExpiredDate.timeIntervalSince(currentDate))
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.day, .hour, .minute], from: currentDate, to: eGiftExpiredDate)
            if let days = dateComponents.day,
                let hours = dateComponents.hour,
                let minutes = dateComponents.minute {
                if (days > 10) {
                    dateLabel.textColor = .c837E85
                    return "HSD: \(expiredDateString)"
                } else if (days >= 1 && days <= 10) {
                    return "Hết hạn sau \(days) ngày"
                } else if (hours > 0) {
                    return "Hết hạn sau \(hours) giờ"
                } else if (minutes > 0) {
                    return "Hết hạn sau \(minutes) phút"
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        return nil
    }
}

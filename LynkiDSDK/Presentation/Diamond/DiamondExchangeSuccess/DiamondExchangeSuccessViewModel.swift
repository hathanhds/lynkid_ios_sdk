//
//  GiftExchangeSuccessViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/06/2024.
//

import Foundation

class DiamondExchangeSuccessViewModel {

    let giftInfo: GiftInfoItem
    let transactionInfo: CreateTransactionItem
    let quantity: Int
    let isEgift: Bool

    init(giftInfo: GiftInfoItem, transactionInfo: CreateTransactionItem, quantity: Int) {
        self.giftInfo = giftInfo
        self.transactionInfo = transactionInfo
        self.quantity = quantity
        self.isEgift = giftInfo.giftInfor?.isEGift ?? false
    }
}

extension DiamondExchangeSuccessViewModel {
    func caculateTicketPosition() -> CGFloat {
        let giftName = giftInfo.giftInfor?.name ?? ""
        let imageHeight = 96.0
        let titleHeight = UtilHelper.heightForLabel(text: giftName, font: .f18s!, width: UtilHelper.screenWidth - 64)
        let space = CGFloat(24 + 8 + 34)
        return CGFloat(imageHeight + titleHeight + space)
    }
}

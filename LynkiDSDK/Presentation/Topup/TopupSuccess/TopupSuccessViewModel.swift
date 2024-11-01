//
//  TopupSuccessViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/08/2024.
//

import Foundation

class TopupSuccessViewModel {

    let data: TopupSuccessArgument

    init(data: TopupSuccessArgument) {
        self.data = data
    }
}

extension TopupSuccessViewModel {
    func caculateTicketPosition() -> CGFloat {
        let giftName = data.title
        let imageHeight = 96.0
        let titleHeight = UtilHelper.heightForLabel(text: giftName, font: .f18s!, width: UtilHelper.screenWidth - 64)
        let totalAmountHeight = 20.0
        let space = CGFloat(24 + 16 + 12 + 24)
        return CGFloat(imageHeight + titleHeight + totalAmountHeight + space)
    }
}

struct TopupSuccessArgument {
    var giftInfo: GiftInfoItem
    var transactionInfo: CreateTransactionItem
    var quantity: Int
    var title: String
    var topupPhoneType: TopupPhoneType?
    var topupDataType: TopupDataType?
    init(giftInfo: GiftInfoItem, transactionInfo: CreateTransactionItem, quantity: Int, title: String, topupPhoneType: TopupPhoneType?, topupDataType: TopupDataType?) {
        self.giftInfo = giftInfo
        self.transactionInfo = transactionInfo
        self.quantity = quantity
        self.title = title
        self.topupPhoneType = topupPhoneType
        self.topupDataType = topupDataType
    }
}

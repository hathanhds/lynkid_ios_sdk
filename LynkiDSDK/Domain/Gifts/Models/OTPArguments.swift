//
//  OTPArguments.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/07/2024.
//

import Foundation

struct OTPArguments {
    var giftsRepository: GiftsRepository
    var sessionId: String
    var quantity: Int
    var giftInfo: GiftInfoItem
    var titleExchangeSuccess: String?
    var topupPhoneType: TopupPhoneType?
    var topupDataType: TopupDataType?

    init(giftsRepository: GiftsRepository, sessionId: String, quantity: Int, giftInfo: GiftInfoItem, titleExchangeSuccess: String? = nil, topupPhoneType: TopupPhoneType? = nil, topupDataType: TopupDataType? = nil) {
        self.giftsRepository = giftsRepository
        self.sessionId = sessionId
        self.quantity = quantity
        self.giftInfo = giftInfo
        self.titleExchangeSuccess = titleExchangeSuccess
        self.topupPhoneType = topupPhoneType
        self.topupDataType = topupDataType
    }
}

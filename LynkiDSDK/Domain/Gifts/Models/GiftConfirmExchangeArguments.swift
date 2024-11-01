//
//  GiftConfirmExchangeArguments.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/07/2024.
//

import Foundation

struct GiftConfirmExchangeArguments {
    var giftsRepository: GiftsRepository
    var giftInfo: GiftInfoItem
    var giftExchangePrice: Double
    var receiverInfo: ReceiverInfoModel?
    init(giftsRepository: GiftsRepository, giftInfo: GiftInfoItem, giftExchangePrice: Double, receiverInfo: ReceiverInfoModel? = nil) {
        self.giftsRepository = giftsRepository
        self.giftInfo = giftInfo
        self.giftExchangePrice = giftExchangePrice
        self.receiverInfo = receiverInfo
    }
}

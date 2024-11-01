//
//  DiamondGiftListResponseModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 19/06/2024.
//

struct DiamondGiftListResponseModel: Codable {
    var data: DiamondGiftListResultModel?
}

struct DiamondGiftListResultModel: Codable {
    var totalCount: Int?
    var items: [GiftInfoItem]?
    var balanceAbleToCashout: Int?

}


struct DiamondGiftInfoItem: Codable {
    let giftInfor: GiftInfor
}

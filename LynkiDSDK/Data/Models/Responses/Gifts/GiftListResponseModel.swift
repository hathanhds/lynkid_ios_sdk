//
//  GiftListResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import Foundation

struct GiftListResponseModel: Codable {
    var data: GiftListResultModel?
}

struct GiftListResultModel: Codable {
    var totalCount: Int?
    var items: [GiftInfoItem]?
    var balanceAbleToCashout: Int?
    var giftCategoryGiftCategoryName: String?
}

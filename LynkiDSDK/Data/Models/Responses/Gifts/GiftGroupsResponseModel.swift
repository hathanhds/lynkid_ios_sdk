//
//  GiftGroupsResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import Foundation

struct GiftGroupsResponseModel: Codable {
    var data: GiftGroupItem?
}

struct GiftGroupItem: Codable {
    var giftGroup: GiftGroup?
    var gifts: [GiftByGroupItem]?
    var numberOfGifts: Int?
}


struct GiftGroup: Codable {
    var code: String?
    var name: String?

    func copyWith(code: String?, name: String?) -> GiftGroup{
        return GiftGroup(code: code, name: name)
    }
}

struct GiftByGroupItem: Codable {
    var giftInfo: GiftInfor?
    var giftDiscountInfor: GiftDiscountInfor?
    var fullLink: String?
}

//
//  AllGiftsByGroupResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/02/2024.
//

import Foundation

struct AllGiftsByGroupResponseModel: Codable {
    var data: AllGiftsByGroupResult?
}

struct AllGiftsByGroupResult: Codable {
    var totalCount: Int?
    var items: [GiftGroupItem]?
}

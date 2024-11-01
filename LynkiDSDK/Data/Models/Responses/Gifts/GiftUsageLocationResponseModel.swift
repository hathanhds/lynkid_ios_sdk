//
//  GiftUsageLocationResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/06/2024.
//

import Foundation

struct GiftUsageLocationResponseModel: Codable {
    var totalCount: Int?
    var items: [GiftUsageLocationItem]?
}

struct GiftUsageLocationItem: Codable {
    var id: Int?
    var name: String?
    var address: String?
    var phone: String?
    var latitude: String?
    var longitude: String?
}

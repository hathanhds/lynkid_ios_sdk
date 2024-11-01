//
//  TopupBrandModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/08/2024.
//

import Foundation

struct TopupBrandModel: Codable {
    var brandMapping: TopupBrandItem?
}

struct TopupBrandItem: Codable {
    var id: Int?
    var code: String?
    var brandId: Int?
    var brandName: String?
    var vendorId: Int?
    var thirdPartyBrandId: String?
    var thirdPartyBrandName: String?
    var isActive: Bool?
    var linkLogo: String?
    var commissPercent: Int?
}

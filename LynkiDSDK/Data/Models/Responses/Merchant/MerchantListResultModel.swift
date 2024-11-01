//
//  MerchantListResultModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 04/06/2024.
//

import Foundation

struct MerchantListResultModel: Codable {
    var result: Int?
    var totalCount: Int?
    var items: [MerchantModel]?
}

//
//  CreateTransactionResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/06/2024.
//

import Foundation

struct CreateTransactionResponseModel: Codable {
    var items: [CreateTransactionItem]?
    var totalCount: Int?
    var isOtpSent: Bool?
}

struct CreateTransactionItem: Codable {
    var code: String?
    var totalCoin: Double?
    var status: String?
    var data: String?
    var description: String?
    var eGift: EGift?
}

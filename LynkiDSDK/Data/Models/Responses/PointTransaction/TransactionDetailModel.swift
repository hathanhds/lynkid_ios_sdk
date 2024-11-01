//
//  TransactionDetailModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 13/06/2024.
//

import Foundation

struct TransactionDetailModel : Codable {
    var id: String?
    var tokenTransId: String?
    var title: String?
    var content: String?
    var amount: Double?
    var actionType: String?
    var actionCode: String?
    var orderCode: String?
    var contentPhoto: String?
    var descriptionPhoto: String?
    var partnerName: String?
    var partnerIcon: String?
    var memberCode: String?
    var walletAddress: String?
    var fromWalletAddress: String?
    var toWalletAddress: String?
    var creationTime: String?
    var expiredTime: String?
    var relatedTokenTransId: String?
    var serviceName: String?
    var packageName: String?
    var cardValue: String?
    var toPhoneNumber: String?
    var usageAddress: String?
    var lastModificationTime: String?
    var giftName: String?
    var giftId: String?
    var giftImage: String?
    var giftPaidCoin: Double?
    var eGiftExpiredDate: String?
    var brandName: String?
    var brandImage: String?
    var vendor: VendorInfo?
    var partnerPointAmount: Double?
    var redeemQuantity: Int?
}


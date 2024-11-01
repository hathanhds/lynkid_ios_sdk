//
//  TopupTransactionListResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/08/2024.
//

import Foundation

struct TopupTransactionListResponseModel: Codable {
    var result: TopupTransactionResultModel?
}

struct TopupTransactionResultModel: Codable {
    var totalCount: Int?
    var items: [TopupTransactionItem]?
}

struct TopupTransactionItem: Codable {
    var id: Int?
    var code: String? // transaction code
    var eGiftCode: String? // mã thẻ
    var eGiftStatus: String?
    var eGiftExpiredDate: String?
    var serialNo: String? // số seri thẻ
    var giftName: String?
    var thirdPartyBrandId: String?
    var creationTime: String?
    var vendorId: Int?
    var requiredCoin: Double?
    var transactionCode: String?
    var thirdPartyCategoryName: String?
    var topupCard: String? // cú pháp nạp thẻ
    var categoryName: String?
    var whyHaveIt: String?
    var status: String?
    var recipientPhone: String?
    var isTopup: Bool?
    var creationDateTime: String? // ngày mua quà
    var fullPrice: Int?
    var brandInfo: TopupBrandInfo?
    
    var eGiftStatusType: TopupUsageStatus? {
        return TopupUsageStatus.allValues.first(where: {$0.rawValue == eGiftStatus})
    }
    
    var whyHaveItType: WhyHaveRewardType? {
        return WhyHaveRewardType.allValues.first(where: {$0.rawValue == whyHaveIt})
    }
    
    var statusType: TopupDeliverStatus? {
        return TopupDeliverStatus.allValues.first(where: {$0.rawValue == status})
    }

}

struct TopupBrandInfo: Codable {
    var brandId: Int?
    var brandName: String?
    var brandImage: String?
    var isBrandFavourite: Bool?
}

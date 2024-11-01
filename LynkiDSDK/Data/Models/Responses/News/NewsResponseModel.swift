//
//  NewsResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 17/01/2024.
//

import Foundation

class NewsResponseModel: Codable {
    var result: NewsResultModel?
}


class NewsResultModel: Codable {
    var totalCount: Int?
    var items = [NewsItem]()
}

class NewsItem: Codable {
    var article: News?
}

class News: Codable {
    var id: Int?
    var code: String?
    var name: String?
    var description: String?
    var content: String?
    var avatar: String?
    var linkAvatar: String?
    var fromDate: String?
    var toDate: String?
    var tags: String?
    var updatedByUser: String?
    var tenantId: String?
    var requiredReadingTime: Int?
    var rewardedCoin: Int?
    var actionCode: String?
    var ordinal: Int?
    var creationTime: String?
    var extraType: String?
}

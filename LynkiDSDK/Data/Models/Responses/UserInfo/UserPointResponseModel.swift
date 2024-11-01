//
//  UserPointResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 06/02/2024.
//

import Foundation

struct UserPointResponseModel: Codable {
    var result: Int?
    var items: UserPoint?
    var messageDetail: String?
    var message: String?
}

struct UserPoint: Codable {
    var id: Int?
    var memberName: String?
    var avatar: String?
    var totalEquivalentAmount: Int?
    var tokenBalance: Int?
    var expiringTokenAmount: Int?
    var expiringDate: String?
    var tempPointBalance: Int?
    var partnerPointBalance: [Merchant]?
    var totalCount: Int?
    var grantTypeBalance: [String]?
    var memberLoyaltyInfo: MemberLoyaltyInfo?
}

struct Merchant: Codable {

}

struct MemberLoyaltyInfo: Codable {
    var memberCode: String?
    var point: Double?
    var coin: Double?
    var rankId: Int?
    var rank: Rank?
    var nextRankId: Int?
    var nextRank: Rank?
    var tempRankId: Int?
    var tempRank: Rank?
    var expiringCoin: Double?
    var pointToNextTempRank: Double?
    var pointToKeepRank: Double?

}

struct Rank: Codable {
    var id: Int?
    var code: String?
    var name: String?
    var target: Double?
    var description: String?
    var avatar: String?
    var isActive: Bool?
    var articleId: Int?
}

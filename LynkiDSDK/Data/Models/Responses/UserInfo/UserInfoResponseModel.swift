//
//  UserInfoResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 02/02/2024.
//

import Foundation

struct UserInfoResponseModel: Codable {
    var result: Int?
    var items: UserInfo?
    var messageDetail: String?
    var message: String?
}

struct UserInfo: Codable {
    var id: Int?
    var userAddress: String?
    var status: String?
    var type: String?
    var name: String?
    var address: String?
    var phoneNumber: String?
    var dob: String?
    var nationalId: String?
    var idCard: String?
    var partnerPhoneNumber: String?
    var pointUsingOrdinary: String?
    var gender: String?
    var email: String?
    var hashAddress: String?
    var regionCode: String?
    var fullRegionCode: String?
    var memberTypeCode: String?
    var fullMemberTypeCode: String?
    var channelType: String?
    var fullChannelTypeCode: String?
    var rankTypeCode: String?
    var standardMemberCode: String?
    var tempPointBalance: Int?
    var tokenBalance: Int?
    var referralCode: String?
    var avatar: String?
    var grantTypeBalance: [GrantTypeBalance]?
    var isIdCardVerified: Bool?
    var hasPinCode: Bool?
    var streetDetail: String?
    var cityId: Int?
    var districtId: Int?
    var wardId: Int?
    var nationId: Int?
}


struct GrantTypeBalance: Codable {
    var grantType: String?
    var balance: Double?
}

//
//  MemberConnectionResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/03/2024.
//

import Foundation

struct MemberConnectionResponseModel: Codable {
    var data: MemberConnectionDataModel?
}

struct MemberConnectionDataModel: Codable {
    var isExisting: Bool?
    var basicInfo: BasicInfoModel?
    var connectionInfo: ConnectionInfoModel?
}

struct ConnectionInfoModel: Codable {
    var isExisting: Bool?
    var connectedToPhone: String?
    var connectedToMemberCode: String?
}

struct BasicInfoModel: Codable {
    var name: String?
    var memberCode: String?
    var balance: Int?
    var accessToken: String?
    var refreshToken: String?
}

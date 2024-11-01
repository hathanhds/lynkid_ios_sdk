//
//  AuthConnectedPhoneResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/03/2024.
//

import Foundation

struct AuthenConnectedPhoneResponseModel: Codable {
    var data: AuthConnectedPhoneDataModel?
}

struct AuthConnectedPhoneDataModel: Codable {
    var newAccessToken: AuthenConnectedPhoneToken?
    var seedTokenReplacement: AuthenConnectedPhoneToken?
}

struct AuthenConnectedPhoneToken: Codable {
    var accessToken: String?
    var refreshToken: String?
}

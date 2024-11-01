//
//  RefreshTokenResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 22/03/2024.
//

import Foundation

struct RefreshTokenResponseModel: Codable {
    var accessToken: String?
    var refreshToken: String?
    var isSuccess: Bool?
    var message: String?
}

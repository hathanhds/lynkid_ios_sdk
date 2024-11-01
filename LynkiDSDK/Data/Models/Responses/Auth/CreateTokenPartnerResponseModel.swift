//
//  CreateTokenPartnerResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/03/2024.
//

import Foundation

struct GenerateTokenPartnerResponseModel: Codable {
    var seedToken: String?
    var code: String?
    var message: String?
    var isSuccess: Bool?
}

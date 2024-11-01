//
//  CreateMemberReponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/03/2024.
//

import Foundation

struct CreateMemberReponseModel: Codable {
    var data: CreateMemberDataModel?
}

struct CreateMemberDataModel: Codable {
    var phoneNumber: String?
    var memberCode: String?
}

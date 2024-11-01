//
//  VpbankMemberInforResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/07/2024.
//

import Foundation

struct VpbankMemberInforResponseModel: Codable {
    var success: Bool?
    var error: String?
    var errorCode: String?
    var memberInfor: VpbankMemberInfor?
}

struct VpbankMemberInfor: Codable {
    var id: Int?
    var idCard: String?
    var cif: String?
    var segment: String?
    var vipCode: String?
}

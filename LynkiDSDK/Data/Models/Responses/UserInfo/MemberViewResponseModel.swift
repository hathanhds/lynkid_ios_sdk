//
//  MemberViewResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/06/2024.
//

import Foundation

struct MemberViewResponseModel: Codable {
    var data: MemberView?
    var message: String?
    var isSuccess: Bool
}

struct MemberView: Codable {
    var id: Int?
    var name: String?
    var phoneNumber: String?
    var avatar: String
    var tokenBalance: Int?
    var address: String?
    var city: LocationModel?
    var district: LocationModel?
    var ward: LocationModel?
    var streetDetail: String?
}

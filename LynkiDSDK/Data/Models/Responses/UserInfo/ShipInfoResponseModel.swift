//
//  ShipInfoModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/06/2024.
//

import Foundation

struct ShipInfoResponseModel: Codable {
    let fullname: String?
    let phone: String?
    let fullLocation: String?
    let note: String?
    let cityId: String?
    let districtId:String?
    let wardId: String?
    let shipAddress: String?
}

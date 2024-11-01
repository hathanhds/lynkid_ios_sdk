//
//  LocationResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/06/2024.
//

import Foundation

struct LocationResponseModel: Codable {
    let totalCount: Int?
    let items: [LocationModel]?
}

struct LocationModel: Codable {
    let id: Int?
    let code: String?
    let name: String?
    let description: String?
    let parentCode: String?
    let internalCode: String?
    let level: String?
}


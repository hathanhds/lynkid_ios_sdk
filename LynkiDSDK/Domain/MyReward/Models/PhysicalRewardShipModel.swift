//
//  PhysicalRewardModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/06/2024.
//

import Foundation

struct PhysicalRewardShipModel: Equatable {
    let fullName: String?
    let phoneNumber: String?
    let address: String?
    let note: String?

    init(fullName: String? = nil,
        phoneNumber: String? = nil,
        address: String? = nil,
        note: String? = nil,
        fullAddress: String? = nil) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.address = address
        self.note = note
    }

    func copyWith(
        fullName: String? = nil,
        phoneNumber: String? = nil,
        address: String? = nil,
        note: String? = nil) -> PhysicalRewardShipModel {
        return PhysicalRewardShipModel(
            fullName: fullName ?? self.fullName,
            phoneNumber: phoneNumber ?? self.phoneNumber,
            address: address ?? self.address,
            note: note ?? self.note)
    }
}

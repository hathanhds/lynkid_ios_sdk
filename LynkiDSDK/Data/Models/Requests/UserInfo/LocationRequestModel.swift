//
//  AddressRequestModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/06/2024.
//

import Foundation

struct LocationRequestModel {
    let parentCodeFilter: String?
    let levelFilter: String?
    let vendorType: String?

    init(parentCodeFilter: String?, levelFilter: String?, vendorType: String?) {
        self.parentCodeFilter = parentCodeFilter
        self.levelFilter = levelFilter
        self.vendorType = vendorType
    }

    func getParams() -> [String: Any] {
        var params = [
            "MaxResultCount": 99
        ] as [String: Any]
        if let parentCodeFilter = parentCodeFilter, !parentCodeFilter.isEmpty {
            params["ParentCodeFilter"] = parentCodeFilter
        }
        if let levelFilter = levelFilter, !levelFilter.isEmpty {
            params["levelFilter"] = levelFilter
        }
        if let vendorType = vendorType, !vendorType.isEmpty {
            params["VendorType"] = vendorType
        }

        return params
    }
}

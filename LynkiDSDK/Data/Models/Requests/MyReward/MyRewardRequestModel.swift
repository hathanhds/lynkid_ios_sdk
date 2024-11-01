//
//  MyRewardRequestModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/05/2024.
//

import Foundation

struct MyRewardRequestModel {
    var limit: Int
    var offset: Int
    var eGiftStatusFilter: String
    var filterModel: MyrewardFilterModel?

    init(limit: Int, offset: Int, eGiftStatusFilter: String, filterModel: MyrewardFilterModel? = nil) {
        self.limit = limit
        self.offset = offset
        self.eGiftStatusFilter = eGiftStatusFilter
        self.filterModel = filterModel
    }

    func getParams() -> [String: Any] {
        var params = [
            "OwnerCodeFilter": AppConfig.shared.memberCode,
            "MaxResultCount": limit,
            "SkipCount": offset,
            "EgiftStatusFilter": eGiftStatusFilter,
            "Sorting": "LastModificationTime desc",
            "Ver": "next",
        ] as [String: Any]

        if let filterModel = filterModel {
            // Loại quà
            if let giftType = filterModel.giftType {
                params["TypeOfGift"] = giftType.id
            }
            // Trạng thái quà
            if let status = filterModel.status {
                if (status.id == "IsNearExpire") {
                    params["IsNearExpire"] = true
                } else {
                    params["EgiftStatusFilter"] = status.id
                }
            }
            // Quà tặng
            if let presentType = filterModel.presentType {
                params["TypeOfTransaction"] = presentType.id
            }
        }
        return params
    }
}

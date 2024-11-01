//
//  TransactionHistoryRequestModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 03/06/2024.
//

import Foundation

struct TransactionHistoryRequestModel {
    var limit: Int
    var offset: Int
    var actionTypeFilter: String
    var orderCode: String?
    
    init(limit: Int, offset: Int, actionTypeFilter: String, orderCode: String? = nil) {
        self.limit = limit
        self.offset = offset
        self.actionTypeFilter = actionTypeFilter
        self.orderCode = orderCode
    }
    
    func getParams() -> [String: Any] {
        var params = [
            "NationalId": AppConfig.shared.memberCode,
            "MaxResultCount": limit,
            "SkipCount": offset,
            "ActionTypeFilter": actionTypeFilter,
            "Sorting": "CreationTime desc",
        ] as [String: Any]
        if let orderCode = orderCode {
            params["OrderCodeFilter"] = orderCode
        }

        return params
    }
}

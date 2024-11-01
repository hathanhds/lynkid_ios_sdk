//
//  TopupTransactionListRequest.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/08/2024.
//

import Foundation

struct TopupTransactionListRequest {
    let limit: Int
    let offset: Int
    let filterCode: String
    let fromDate: String?
    let toDate: String?
    let usageStatus: String?
    let brandId: String?

    init(limit: Int, offset: Int, filterCode: String, fromDate: String? = nil, toDate: String? = nil, usageStatus: String? = nil, brandId: String? = nil) {
        self.limit = limit
        self.offset = offset
        self.filterCode = filterCode
        self.fromDate = fromDate
        self.toDate = toDate
        self.usageStatus = usageStatus
        self.brandId = brandId
    }

    func getParams() -> [String: Any] {
        var params = [
            "MemberCodeFilter": AppConfig.shared.memberCode,
            "MaxResultCount": limit,
            "SkipCount": offset,
            "StatusFilter": "Delivered",
            "FullGiftCategoryCodeFilter": filterCode,
        ] as [String: Any]

        if let brandId = brandId {
            params["BrandIdFilter"] = brandId
        }
        
        if let fromDate = fromDate {
            params["FromDateFilter"] = fromDate
        } else {
            params["FromDateFilter"] = get90DaysAgo()
        }
        if let toDate = toDate {
            params["ToDateFilter"] = toDate
        }
        if let usageStatus = usageStatus {
            params["EgiftStatusFilter"] = usageStatus
        }

        return params
    }

    func get90DaysAgo() -> String {
        let currentDate = Date()
        if let ninetyDaysAgo = Calendar.current.date(byAdding: .day, value: -90, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatterType.yyyyMMddThhmmssSSZ.value
            // Set the time zone to UTC
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            // Convert the date to a string
            let utcDateString = dateFormatter.string(from: ninetyDaysAgo)
            return utcDateString
        }
        return ""
    }

}

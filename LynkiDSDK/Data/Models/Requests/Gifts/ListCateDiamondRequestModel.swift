//
//  AllGiftsRequestModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/02/2024.
//

import Foundation

struct ListCateDiamondRequestModel {
    var maxLevelFilter: String
    var maxItem: String
    var statusFilter: String
    var sorting: String
    var showTopupCategory: String
    var parentCodeFilter: String?

    init(maxLevelFilter: String,
         maxItem: String = "5",
         statusFilter: String = "A",
         sorting: String = "CreationTime desc",
         showTopupCategory: String = "false",
         parentCodeFilter: String?
    ) {
        self.maxLevelFilter = maxLevelFilter
        self.maxItem = maxItem
        self.statusFilter = statusFilter
        self.sorting = sorting
        self.showTopupCategory = showTopupCategory
        self.parentCodeFilter = parentCodeFilter
    }

    func getParams() -> [String: Any] {
      
        var params = [
            "MemberCode": AppConfig.shared.memberCode,
            "MaxLevelFilter": maxLevelFilter,
            "MaxItem": maxItem,
            "StatusFilter": statusFilter,
            "Sorting": sorting,
            "ShowTopupCategory": showTopupCategory,
            
        ] as [String: Any]
        
        if let parentCodeFilter = parentCodeFilter{
            params["ParentCodeFilter"] = parentCodeFilter
        }
 
        return params
    }
}

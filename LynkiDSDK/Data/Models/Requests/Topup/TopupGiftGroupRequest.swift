//
//  TopupGiftGroupRequest.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/08/2024.
//

import Foundation

struct TopupGiftGroupRequest {
    let brandIdFilter: Int
    let groupType: Int
    
    init(brandIdFilter: Int, groupType: Int) {
        self.brandIdFilter = brandIdFilter
        self.groupType = groupType
    }
    
    func getParams() -> [String: Any] {
        var params = [
            "MemberCode":  AppConfig.shared.memberCode,
            "MaxResultCount": 100,
            "SkipCount": 0,
            "MaxItem": 5,
            "BrandIdFilter": brandIdFilter,
            "GroupTypeFilter": groupType
        ] as [String: Any]
        
        return params
    }
}

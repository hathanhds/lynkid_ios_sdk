//
//  TopupGiftListRequest.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/08/2024.
//

import Foundation

struct TopupGiftListRequest {
    let brandIdFilter: Int
    let cateCode: String
    
    init(brandIdFilter: Int, cateCode: String) {
        self.brandIdFilter = brandIdFilter
        self.cateCode = cateCode
    }
    
    func getParams() -> [String: Any] {
        var params = [
            "MemberCode":  AppConfig.shared.memberCode,
            "MaxResultCount": 1000,
            "SkipCount": 0,
            "MaxItem": 5,
            "Sorting": "RequiredCoin",
            "GiftTypeFilter": "TopupPhone",
            "FullGiftCategoryCode": cateCode,
            "BrandIdFilter": brandIdFilter
        ] as [String: Any]
        
        return params
    }
}

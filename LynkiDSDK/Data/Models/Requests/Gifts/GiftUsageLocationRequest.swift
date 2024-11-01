//
//  GiftUsageLocationRequest.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/06/2024.
//

import Foundation

struct GiftUsageLocationRequest {
    var name: String?
    var giftCode: String
    var offset: Int
    var limit: Int
    
    init(name: String? = nil, giftCode: String, offset: Int, limit: Int = 10) {
        self.name = name
        self.giftCode = giftCode
        self.offset = offset
        self.limit = limit
    }
    
    func getParams() -> [String: Any] {
        var params = [
            "MaxResultCount": limit,
            "SkipCount": offset,
            "GiftCode": giftCode,
        ] as [String: Any]
        if let name = name {
            params["Name"] = name
        }
        return params
    }
}

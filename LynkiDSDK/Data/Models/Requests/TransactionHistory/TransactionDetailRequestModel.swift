//
//  TransactionDetailRequestModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 04/06/2024.
//

import Foundation

struct TransactionDetailRequestModel {
    var tokenTransID: String
    
    init(tokenTransID: String) {
        self.tokenTransID = tokenTransID
    }
    
    func getParams() -> [String: Any] {
        let params = [
            "MemberCode": AppConfig.shared.memberCode,
            "TokenTransId": tokenTransID
        ] as [String: Any]

        return params
    }
}

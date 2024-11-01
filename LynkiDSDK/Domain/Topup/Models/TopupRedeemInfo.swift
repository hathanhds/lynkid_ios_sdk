//
//  TopupRedeemInfoModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/08/2024.
//

import Foundation

//   {'operation':1200,'ownerPhone':'0342453073','accountType':0}"
// Trong đó:
// -    Operation:
// Mua mã thẻ : 1000
// Mua thẻ nạp: 1200
// -    ownerPhone: SĐT nạp
// -    accountType
// Trả trước: 0
// Trả sau: 1

struct TopupRedeemInfo: Codable {
    var operation: Int?
    var ownerPhone: String?
    var accountType: Int?

    init(operation: Int?, ownerPhone: String?, accountType: Int?) {
        self.operation = operation
        self.ownerPhone = ownerPhone
        self.accountType = accountType
    }

    func fromJson(json: String) -> TopupRedeemInfo? {
        if let jsonData = json.data(using: .utf8), let model = try? jsonData.decoded(type: TopupRedeemInfo.self) {
            return model
        }
        return nil
    }
}

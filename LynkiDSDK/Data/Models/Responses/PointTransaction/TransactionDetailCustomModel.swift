//
//  TransactionDetailCustomModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 12/06/2024.
//

import Foundation

enum TransactionDetailItemStyle {
    case trasaction_info_normal
    case trasaction_info_related_transaction
    case trasaction_info_gift_detail
    case trasaction_info_support
}

class TransactionDetailCustomModel {
    var id: Int
    var leftText: String
    var rightText: String
    var logo: String
    var isDate = false
    var type:TransactionDetailItemStyle
    var data:TransactionDetailModel?

    
    init(id: Int, leftText: String? = "", rightText: String? = "", logo:String? = "", isDate: Bool = false, type:TransactionDetailItemStyle, data:TransactionDetailModel? = nil) {
        self.id = id
        self.leftText = leftText ?? ""
        self.rightText = rightText ?? ""
        self.logo = logo ?? ""
        self.isDate = isDate
        self.type = type
        self.data = data ?? nil
    }
}

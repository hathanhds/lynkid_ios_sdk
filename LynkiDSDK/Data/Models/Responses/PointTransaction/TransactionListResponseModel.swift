//
//  TransactionListResponseModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 03/06/2024.
//

import Foundation

struct TransactionListResultModel: Codable {
    var result: Int?
    var totalCount: Int?
    var items: [TransactionItem]?
}

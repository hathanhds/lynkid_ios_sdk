//
//  TransactionDetailResponseModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 04/06/2024.
//

import Foundation

struct TransactionDetailResponseModel : Codable {
    var result: TransactionDetailModel?
    var isSuccess: Bool?
    var message: String?
}

//
//  TransactionItemModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 03/06/2024.
//

import Foundation


struct TransactionItem: Codable {
    var tokenTransID: String
    var memberId: Int?
    var time: String?
    var businessTime: String?
    var validDate: String?
    var expiryDate: String?
    var orderCode: String?
    var actionCode: String?
    var actionCodeDetail: String?
    var actionName: String?
    var fromWalletAddress: String?
    var fromMerchantNameOrMember: String?
    var toWalletAddress: String?
    var toMerchantNameOrMember: String?
    var storeId: Int?
    var storeName: String?
    var nationalId: String?
    var userAddress: String?
    var actionType: String?
    var tokenAmount: Double?
    var partnerPointAmount: Double?
    var pointExchangeRate: Double?
    var currencyExchangeRate: Double?
    var grantType: String?
    var usagePriority: String?
    var partnerBindingTxId: String?
    var reason: String?
    var merchantId: Int?
    var baseUnit: Int?
    var topUpVendorName: String?
    var topUpVendorAvatar: String?
    var adjustTransactionList: [String]? // Assuming this is an array of strings; adjust if the structure is different

    private enum CodingKeys: String, CodingKey {
        case tokenTransID = "tokenTransID"
        case memberId = "memberId"
        case time = "time"
        case businessTime = "businessTime"
        case validDate = "validDate"
        case expiryDate = "expiryDate"
        case orderCode = "orderCode"
        case actionCode = "actionCode"
        case actionCodeDetail = "actionCodeDetail"
        case actionName = "actionName"
        case fromWalletAddress = "fromWalletAddress"
        case fromMerchantNameOrMember = "fromMerchantNameOrMember"
        case toWalletAddress = "toWalletAddress"
        case toMerchantNameOrMember = "toMerchantNameOrMember"
        case storeId = "storeId"
        case storeName = "storeName"
        case nationalId = "nationalId"
        case userAddress = "userAddress"
        case actionType = "actionType"
        case tokenAmount = "tokenAmount"
        case partnerPointAmount = "partnerPointAmount"
        case pointExchangeRate = "pointExchangeRate"
        case currencyExchangeRate = "currencyExchangeRate"
        case grantType = "grantType"
        case usagePriority = "usagePriority"
        case partnerBindingTxId = "partnerBindingTxId"
        case reason = "reason"
        case merchantId = "merchantId"
        case baseUnit = "baseUnit"
        case topUpVendorName = "topUpVendorName"
        case topUpVendorAvatar = "topUpVendorAvatar"
        case adjustTransactionList = "adjustTransactionList"
    }
}

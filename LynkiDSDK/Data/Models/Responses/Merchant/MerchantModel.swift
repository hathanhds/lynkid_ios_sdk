//
//  MerchantModel.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 04/06/2024.
//

import Foundation

struct MerchantModel: Codable {
    var walletAddress: String?
    var id: Int?
    var merchantName: String?
    var address: String?
    var phone: String?
    var status: String?
    var logo: String?
    var type: String?
    var createdAt: String?
    var baseUnit: Int?
    var pointExchangeRate: Int?
    var maintenanceFrom: String?
    var maintenanceTo: String?
    var maintenanceStatus: String?
    var isAKCLoyalty: Bool?
    var isChangedLoyalty: Bool?
    var isVerified: String?
    var x1lTenantId: String?
    var orgId: String?
    var storeList: [StoreList]?
    var balance: Int?
    var bindingStatus: Bool?
    var accessInfo: Double?
    var userInfo: Double?
    var partnerPhoneNumber: String?
    var partnerIdCard: String?
    var coinIcon: String?
    var connectSource: String?
    var additionalData: AdditionalData?
}


struct StoreList: Codable {
    var id: Int?
    var merchantId: Int?
    var storeName: String?
    var unsignName: String?
    var phoneNumber: String?
    var address: String?
    var email: String?
    var status: String?
    var avatar: String?
    var region: String?
    var longitude: String?
    var description: String?
    var latitude: String?
}


struct AdditionalData: Codable {
    var id: Int?
    var createdAt: String?
    var updatedAt: String?
    var isDeleted: Bool?
    var merchantId: Int?
    var introduction: String?
    var hotline: String?
    var website: String?
    var coverPhoto: String?
    var earningDescription: String?
    var showedUsers: Int?
}

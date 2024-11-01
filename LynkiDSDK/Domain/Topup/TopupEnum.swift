//
//  TopupEnum.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/08/2024.
//

import Foundation

enum TopupType: String {
    case topupPhone = "Phone" // thẻ điện thoại
    case topupData = "Data" // data

    var title: String {
        switch self {
        case .topupPhone:
            return "Điện thoại"
        case .topupData:
            return "Data 3G/4G"
        }
    }
}

enum TopupPhoneType: String, CaseIterable {
    case prePaid = "Trả trước"
    case postPaid = "Trả sau"
    case buyCard = "Đổi mã thẻ"

    var serviceName: String {
        switch self {
        case .prePaid:
            return "Nạp tiền điện thoại trả trước"
        case .postPaid:
            return "Nạp tiền điện thoại trả sau"
        case .buyCard:
            return "Đổi mã thẻ nạp điện thoại"
        }
    }

    var paidType: Int? {
        switch self {
        case .prePaid:
            return 0
        case .postPaid:
            return 1
        case .buyCard:
            return 0
        }
    }
}

enum TopupDataType: String, CaseIterable {
    case topup = "Nạp data"
    case buyCard = "Đổi mã thẻ"

    var serviceName: String {
        switch self {
        case .topup:
            return "Nạp Data 3G/4G"
        case .buyCard:
            return "Đổi mã thẻ Data 3G/4G"
        }
    }
}

enum TopupBrandType {
    case viettel, vinaphone, mobifone, vnmobile, beeline, reddi
}

enum TopupUsageStatus: String {
    case used = "Used"
    case expired = "Expired"
    case redeemed = "Redeemed"

    static let allValues = [used, expired, redeemed]
}

enum TopupDeliverStatus: String {
    case pending = "Pending"
    case rejected = "Rejected"
    case delivered = "Delivered"

    static let allValues = [pending, rejected, delivered]
}

enum TopupChannel: String {
    case ussd = "USSD"
    case sms = "SMS"
}

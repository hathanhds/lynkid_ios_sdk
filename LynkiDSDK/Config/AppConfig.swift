//
//  AppConfig.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/03/2024.
//

import Foundation

class AppConfig {
    static let shared = AppConfig()
    private init() { }

    var accessToken = ""
    var refreshToken = ""
    var seedToken = ""
    var refreshSeedToken = ""
    var phoneNumber = ""
    var cif = ""
    var memberCode = ""
    var partnerCode = ""
    var userName = ""
    var connectedPhone = ""
    var connectedMemberCode = ""
    var merchantName = ""
    var viewMode: ViewMode = .anonymous

    var phoneNumberFormatter: String {
        return phoneNumber.phoneNumberFormatter()
    }

    var connectedPhoneNumberFormatter: String {
        return connectedPhone.phoneNumberFormatter()
    }
}

enum ViewMode {
    case anonymous
    case authenticated
}

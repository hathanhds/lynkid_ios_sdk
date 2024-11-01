//
//  NotificationCenter+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 06/02/2024.
//

import UIKit

extension NSNotification.Name {
    static let networkIsConnected = Self(rawValue: "NetworkIsConnectd")
    static let networkIsNotConnected = Self(rawValue: "NetworkIsNotConnectd")
    static let updateUerCoin = Self(rawValue: "UpdateUerCoin")
    static let updateMyRewardList = Self(rawValue: "UpdateMyRewardList")
    static let updateTopupTransactionList = Self(rawValue: "UpdateTopupTransactionList")
    static let updateTransactionHistory = Self(rawValue: "UpdateTransactionHistory")
}


extension NotificationCenter {
    static func dispatch(name: NSNotification.Name, payload: [String: String] = [:]) {
        self.default.post(name: name, object: nil, userInfo: payload)
    }
    static func observe(name: NSNotification.Name, handler: @escaping (Notification) -> Void) {
        self.default.addObserver(forName: name, object: nil, queue: .main, using: handler)
    }

}

//
//  UIStoryboard+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//

import UIKit

extension UIStoryboard {

    convenience init(name: String) {
        self.init(name: name, bundle: UIStoryboard.bundle)
    }

    func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}

extension UIStoryboard {
    static let bundle = Bundle(for: LaunchScreenViewController.self)
    static let main = UIStoryboard(name: "Main")
    static let popup = UIStoryboard(name: "Popup")
    static let home = UIStoryboard(name: "Home")
    static let myReward = UIStoryboard(name: "MyReward")
    static let transactionHistory = UIStoryboard(name: "TransactionHistory")
    static let userInfo = UIStoryboard(name: "UserInfo")
    static let splashScreen = UIStoryboard(name: "SplashScreen")
    static let gifts = UIStoryboard(name: "Gifts")
    static let giftExchange = UIStoryboard(name: "GiftExchange")
    static let auth = UIStoryboard(name: "Auth")
    static let anonymous = UIStoryboard(name: "Anonymous")
    static let diamond = UIStoryboard(name: "Diamond")
    static let topup = UIStoryboard(name: "Topup")
}

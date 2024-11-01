//
//  AppAppearance.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/01/2024.
//

import Foundation
import UIKit
import EasyTipView

final class AppAppearance {

    static func setupAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .mainColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().tintColor = .white
        } else {
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().backgroundColor = .mainColor
        }
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

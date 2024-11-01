//
//  Config.swift
//  SDKTest
//
//  Created by ThanhNTH on 04/04/2024.
//

import UIKit
import IQKeyboardManagerSwift

public class LynkiD {

    public static let shared = LynkiD()

    public func initSDK(cif: String,
        phoneNumber: String,
        userName: String,
        partnerCode: String,
        merchantName: String,
        presentAction: ((_ vc: UIViewController) -> Void)) {

        // Config
        configApp()

        // Init userinfo
        AppConfig.shared.cif = cif
        AppConfig.shared.phoneNumber = phoneNumber
        AppConfig.shared.userName = userName
        AppConfig.shared.partnerCode = partnerCode
        AppConfig.shared.merchantName = merchantName

        let vc = LaunchScreenViewController.create(with: Navigator(), viewModel: LaunchScreenViewModel(authenRepository: AuthRepositoryImp()))
        presentAction(UINavigationController(rootViewController: vc))
    }

    func configApp() {
        NetworkManager.shared.startListening()
        UIFont.loadFonts()
        IQKeyboardManager.shared.enable = true
    }
}

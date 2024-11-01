//
//  InstallAppPopupViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/03/2024.
//

import Foundation

class InstallAppPopupViewModel {

    let isVpbankDiamond: Bool
    let isTabbar: Bool
    init(isVpbankDiamond: Bool = false, isTabbar: Bool = false) {
        self.isVpbankDiamond = isVpbankDiamond
        self.isTabbar = isTabbar
    }
}

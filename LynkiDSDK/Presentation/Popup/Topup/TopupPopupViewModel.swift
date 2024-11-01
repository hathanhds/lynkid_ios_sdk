//
//  TopupPopupViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/08/2024.
//

import Foundation

enum TopupPopupType: String {
    case copy = "Sao chép"
    case topup = "Nạp ngay"
}

class TopupPopupViewModel {
    let list: [TopupPopupModel]
    let type: TopupPopupType
    let onSelected: ((_ data: TopupPopupModel) -> Void)
    init(data: TopupPopupArgument) {
        self.list = data.list
        self.type = data.type
        self.onSelected = data.onSelected
    }
}

struct TopupPopupArgument {
    let list: [TopupPopupModel]
    let type: TopupPopupType
    let onSelected: ((_ data: TopupPopupModel) -> Void)
    init(list: [TopupPopupModel], type: TopupPopupType, onSelected: @escaping (_: TopupPopupModel) -> Void) {
        self.list = list
        self.type = type
        self.onSelected = onSelected
    }
}

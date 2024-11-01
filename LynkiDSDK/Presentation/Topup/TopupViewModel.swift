//
//  TopupViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 09/08/2024.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class TopupViewModel {
    var topupType: TopupType
    init(topupType: TopupType) {
        self.topupType = topupType
    }
}

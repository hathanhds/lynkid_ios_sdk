//
//  PopupAnonymousViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 31/07/2024.
//

import Foundation
import RxSwift
import RxCocoa

class PopupLoginViewModel {

    private let disposeBag = DisposeBag()
    let isDiamond: Bool

    init(isDiamond: Bool = false) {
        self.isDiamond = isDiamond
    }
}

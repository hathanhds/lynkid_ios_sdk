//
//  PopupWithTwoOptionsViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/05/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum PopupType {
    case noOption
    case oneOption
    case twoOption
}

class PopupViewModel: ViewModelType {
    typealias ConfirmButton = (title: String?, action: (() -> Void)?)
    typealias CancelButton = (title: String?, action: (() -> Void)?)

    private let disposeBag = DisposeBag()

    struct Input {
        let confirmAction: AnyObserver<Void>
        let cancelAction: AnyObserver<Void>
    }

    struct Output {
        let dismissable: Bool?
        let isDiamond: Bool
        let type: PopupType
        let title: String
        let image: UIImage
        let message: String
        let cancelButtonTitle: String?
        let confirmButtonTitle: String?
    }

    let input: Input
    private let confirmActionSubj = PublishSubject<Void>()
    private let cancelActionSubj = PublishSubject<Void>()
    let output: Output

    init(dismissable: Bool? = true, 
         isDiamond: Bool = false,
         type: PopupType,
         title: String = "",
         message: String = "",
         image: UIImage = .imageMascotError!
        , confirmnButton: ConfirmButton? = nil, cancelButton: CancelButton? = nil) {
        self.input = Input(confirmAction: self.confirmActionSubj.asObserver(), 
                           cancelAction: self.cancelActionSubj.asObserver())
        self.output = Output(dismissable: dismissable,
                             isDiamond: isDiamond,
                             type: type,
                             title: title,
                             image: image,
                             message: message,
                             cancelButtonTitle: cancelButton?.title, 
                             confirmButtonTitle: confirmnButton?.title)

        self.confirmActionSubj
            .subscribe(onNext: { _ in
            if let confirmnButton = confirmnButton, let action = confirmnButton.action {
                action()
            }
        })
            .disposed(by: self.disposeBag)

        self.cancelActionSubj
            .subscribe(onNext: { _ in
            if let cancelButton = cancelButton, let action = cancelButton.action {
                action()
            }
        })
            .disposed(by: self.disposeBag)
    }
}

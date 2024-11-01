//
//  PopupWithTwoOptionsViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/05/2024.
//

import Foundation
import RxSwift
import RxCocoa



class PopupDiamondFilterViewModel: ViewModelType {
    typealias CloseButton = ((() -> Void))
    typealias ApplyButton = (((GiftSorting) -> Void))
    typealias SelectMostPopularButton = ((() -> Void))
    typealias SelectCheapestButton = ((() -> Void))

    private let disposeBag = DisposeBag()

    struct Input {
        let closeAction: AnyObserver<Void>
        let applyAction: AnyObserver<Void>
        let selectMostPopularOptionAction: AnyObserver<Void>
        let selectCheapestOptionAction: AnyObserver<Void>
    }

    struct Output {
        let dismissable: Bool?
        let selectedOption: BehaviorRelay<GiftSorting>
    }

    let input: Input
    private let closeActionSubj = PublishSubject<Void>()
    private let applyActionSubj = PublishSubject<Void>()
    private let selectMostPopularOptionSubj = PublishSubject<Void>()
    private let selectCheapestOptionSubj = PublishSubject<Void>()
    private let selectedOptionSubj = BehaviorRelay<GiftSorting>(value: .popular)
    
    let output: Output

    init(dismissable: Bool? = true,
         selectedOption:GiftSorting,
         closeButtonAction: CloseButton? = nil,
         applyButtonAction: ApplyButton? = nil,
         selectMostPopularOptionAction: SelectMostPopularButton? = nil,
         selectCheapestOptionAction: SelectCheapestButton? = nil) {
        self.selectedOptionSubj.accept(selectedOption)
        self.input = Input(closeAction: self.closeActionSubj.asObserver(), applyAction: self.applyActionSubj.asObserver(), selectMostPopularOptionAction: self.selectMostPopularOptionSubj.asObserver(), selectCheapestOptionAction: self.selectCheapestOptionSubj.asObserver())
        self.output = Output(dismissable: dismissable, selectedOption: selectedOptionSubj)

        self.closeActionSubj
            .subscribe(onNext: { _ in
            if let action = closeButtonAction {
                action()
            }
        })
            .disposed(by: self.disposeBag)

        self.applyActionSubj
            .subscribe(onNext: { _ in
            if let action = applyButtonAction {
                action(self.output.selectedOption.value)
            }
        })
            .disposed(by: self.disposeBag)
        
        self.selectMostPopularOptionSubj
            .subscribe(onNext: { _ in
            if let action = selectMostPopularOptionAction {
                action()
            }
                self.selectedOptionSubj.accept(.popular)
        })
            .disposed(by: self.disposeBag)
        
        self.selectCheapestOptionSubj
            .subscribe(onNext: { _ in
            if let action = selectCheapestOptionAction {
                action()
            }
                self.selectedOptionSubj.accept(.priceLasted)
        })
            .disposed(by: self.disposeBag)
    }
}

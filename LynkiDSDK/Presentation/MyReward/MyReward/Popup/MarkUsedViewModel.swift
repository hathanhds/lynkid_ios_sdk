//
//  MarkUsedViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 21/05/2024.
//

import Foundation
import RxSwift

class MarkUsedViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    struct Input {
        let didFinish: AnyObserver<Void>
    }

    struct Output {

    }

    let input: Input
    let didFinishSubj = PublishSubject<Void>()

    let output: Output


    init(didFinish: @escaping () -> Void) {
        self.input = Input(didFinish: didFinishSubj.asObserver())
        self.output = Output()

        self.didFinishSubj
            .subscribe(onNext: { _ in
            didFinish()
        })
            .disposed(by: self.disposeBag)


    }
}

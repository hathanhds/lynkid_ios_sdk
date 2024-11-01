//
//  TermsAndPolicyViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum TermsAndPolicyType {
    case terms
    case policy
}

class TermsAndPolicyViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let authRepository: AuthRepository

    struct Input {

    }

    struct Output {
        let htmlString: BehaviorRelay<String>
        let title: BehaviorRelay<String>
        let isLoading: BehaviorRelay<Bool>
    }

    let input: Input

    let output: Output
    let htmlStringSubj = BehaviorRelay<String>(value: "")
    let isLoadingSubj = BehaviorRelay<Bool>(value: false)
    let titleSubj = BehaviorRelay<String>(value: "")

    let type: TermsAndPolicyType

    init(type: TermsAndPolicyType, authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.type = type
        self.input = Input()
        self.output = Output(htmlString: htmlStringSubj, title: titleSubj, isLoading: isLoadingSubj)
        titleSubj.accept(type == .terms ? "Điều khoản & Điều kiện" : "Chính sách bảo mật")
    }

    func getTermsOrPolicy() {
        isLoadingSubj.accept(true)
        authRepository.getTermsOrPolicy(type: self.type).subscribe { [weak self] res in
            guard let self = self else { return }
            if let article = res.result?.items.first?.article {
                titleSubj.accept(article.name ?? "")
                htmlStringSubj.accept(article.content ?? "")
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)

    }

}

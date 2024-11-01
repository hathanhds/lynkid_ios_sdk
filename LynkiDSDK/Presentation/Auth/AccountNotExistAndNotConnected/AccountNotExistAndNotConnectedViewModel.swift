//
//  AccountNotExistAndNotConnectedViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import RxSwift
import RxCocoa


class AccountNotExistAndNotConnectedViewModel: ViewModelType {
    let authenRepository: AuthRepository
    let disposeBag = DisposeBag()

    struct Input {
        let onAccept: AnyObserver<Void>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let createMemberResult: Observable<Result<Void, APIErrorResponseModel>>
    }

    let input: Input
    let onAcceptSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay<Bool>(value: false)
    let createMemberResultSubj = PublishSubject<Result<Void, APIErrorResponseModel>>()

    init(authenRepository: AuthRepository) {
        self.authenRepository = authenRepository
        self.input = Input(
            onAccept: onAcceptSubj.asObserver())
        self.output = Output(
            isLoading: isLoadingSubj,
            createMemberResult: createMemberResultSubj)

        self.onAcceptSubj.subscribe(onNext: { [weak self] in
            self?.createMember()
        }).disposed(by: self.disposeBag)
    }

    func createMember() {
        isLoadingSubj.accept(true)
        authenRepository.createMember(
            phoneNumber: AppConfig.shared.phoneNumber.formatVietnamesePhoneNumber(),
            cif: AppConfig.shared.cif,
            name: AppConfig.shared.userName)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let basicInfo = res.data?.basicInfo {
                AppConfig.shared.accessToken = basicInfo.accessToken ?? ""
                AppConfig.shared.refreshToken = basicInfo.refreshToken ?? ""
                AppConfig.shared.accessToken = basicInfo.memberCode ?? ""
            }
            self.isLoadingSubj.accept(false)
            self.createMemberResultSubj.onNext(.success(()))
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            self.isLoadingSubj.accept(false)
            if let error = error as? APIErrorResponseModel {
                self.createMemberResultSubj.onNext(.failure(error))
            } else {
                self.createMemberResultSubj.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
            }
        }.disposed(by: disposeBag)
    }
}

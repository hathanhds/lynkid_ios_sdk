//
//  AccountNotExistAndConnectedViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum SelectedType {
    case connected
    case notConnected
}

class AccountNotExistAndConnectedViewModel: ViewModelType {
    let authenRepository: AuthRepository
    let disposeBag = DisposeBag()

    struct Input {
        let onSelectPhone: AnyObserver<SelectedType>
        let onAccept: AnyObserver<Navigator>
    }

    struct Output {
        let selectedType: BehaviorRelay<SelectedType>
        let isLoading: BehaviorRelay<Bool>
        let createMemberResult: Observable<Result<Void, APIErrorResponseModel>>
    }

    let input: Input
    let onSelectPhoneSubj = PublishSubject<SelectedType>()
    let onAcceptSubj = PublishSubject<Navigator>()

    let output: Output
    let selectedTypeSubj = BehaviorRelay<SelectedType>(value: .connected)
    let isLoadingSubj = BehaviorRelay<Bool>(value: false)
    let createMemberResultSubj = PublishSubject<Result<Void, APIErrorResponseModel>>()

    init(authenRepository: AuthRepository) {
        self.authenRepository = authenRepository
        self.input = Input(
            onSelectPhone: onSelectPhoneSubj.asObserver(),
            onAccept: onAcceptSubj.asObserver())
        self.output = Output(selectedType: selectedTypeSubj,
            isLoading: isLoadingSubj,
            createMemberResult: createMemberResultSubj
        )

        self.onSelectPhoneSubj.subscribe { [weak self] selectedType in
            guard let self = self else { return }
            selectedTypeSubj.accept(selectedType)
        }.disposed(by: disposeBag)
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
                AppConfig.shared.memberCode = basicInfo.memberCode ?? ""
            }
            self.createMemberResultSubj.onNext(.success(()))
            self.isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            if let error = error as? APIErrorResponseModel {
                self.createMemberResultSubj.onNext(.failure(error))
            } else {
                self.createMemberResultSubj.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
            }
            self.isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }
}

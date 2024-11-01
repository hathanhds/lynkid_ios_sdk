//
//  AuthenConnectedPhoneNumberViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 14/03/2024.
//

import Foundation
import RxSwift
import RxCocoa


class AuthenConnectedPhoneNumberViewModel: ViewModelType {
    let authRepository: AuthRepository
    let disposeBag = DisposeBag()

    struct Input {
        let onContinue: AnyObserver<String?>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let authenConnectedPhoneResult: Observable<Result<Void, Error>>
    }

    let input: Input
    let onContinueSubj = PublishSubject<String?>()

    let output: Output
    let isLoadingSubj = BehaviorRelay<Bool>(value: false)
    let authenConnectedPhoneResultSubj = PublishSubject<Result<Void, Error>>()

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.input = Input(onContinue: onContinueSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj,
            authenConnectedPhoneResult: authenConnectedPhoneResultSubj)

        self.onContinueSubj.subscribe(onNext: { [weak self] phoneNumber in
            if let self = self, let phoneNumber = phoneNumber, !phoneNumber.isEmpty {
                self.authenConnectedPhone(inputPhoneNumber: phoneNumber)
            }
        }).disposed(by: self.disposeBag)
    }

    func authenConnectedPhone(inputPhoneNumber: String) {
        isLoadingSubj.accept(true)
        authRepository.authenWithConnectedPhone(
            originalPhone: AppConfig.shared.phoneNumber.formatVietnamesePhoneNumber(), connectedPhone: inputPhoneNumber.formatVietnamesePhoneNumber())
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.data {
                // Gán thông tin connected info cho user info
                AppConfig.shared.phoneNumber = AppConfig.shared.connectedPhone
                AppConfig.shared.memberCode = AppConfig.shared.connectedMemberCode
                if let tokenData = data.newAccessToken {
                    AppConfig.shared.accessToken = tokenData.accessToken ?? ""
                    AppConfig.shared.refreshToken = tokenData.refreshToken ?? ""
                }
                if let seedTokenData = data.seedTokenReplacement {
                    AppConfig.shared.seedToken = seedTokenData.accessToken ?? ""
                    AppConfig.shared.refreshSeedToken = seedTokenData.refreshToken ?? ""
                }
            }
            self.isLoadingSubj.accept(false)
            self.authenConnectedPhoneResultSubj.onNext(.success(()))
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            self.authenConnectedPhoneResultSubj.onNext(.failure(error))
            self.isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }


}

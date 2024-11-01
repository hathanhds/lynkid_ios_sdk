//
//  LaunchScreenViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum AuthScreenType {
    case existAndConnected
    case existAndNotConnected
    case notExistAndConnected
    case notExistAndNotConnected
}

class LaunchScreenViewModel: ViewModelType {

    private let disposeBag = DisposeBag()
    private let authenRepository: AuthRepository

    struct Input {

    }

    struct Output {
        let isShowError: BehaviorRelay<Bool>
        let isLoading: BehaviorRelay<Bool>
        let nextScreenType: BehaviorRelay<AuthScreenType?>
    }

    let input: Input

    let output: Output
    let isShowErrorSubj = BehaviorRelay(value: false)
    let isLoadingSubj = BehaviorRelay(value: false)
    let nextScreenTypeSubj = BehaviorRelay<AuthScreenType?>(value: nil)

    init(authenRepository: AuthRepository) {
        self.authenRepository = authenRepository

        self.input = Input()
        self.output = Output(
            isShowError: isShowErrorSubj,
            isLoading: isLoadingSubj,
            nextScreenType: nextScreenTypeSubj
        )
    }

    func didLoad() {
//        generatePartnerToken()
    }

    func generatePartnerToken() {
        isLoadingSubj.accept(true)
        authenRepository.generatePartnerToken(
            phoneNumber: AppConfig.shared.phoneNumber.formatVietnamesePhoneNumber(),
            cif: AppConfig.shared.cif,
            name: AppConfig.shared.userName)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            AppConfig.shared.seedToken = res.seedToken ?? ""
            checkMemberAndConnection()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            self.isLoadingSubj.accept(false)
            self.isShowErrorSubj.accept(true)
        }.disposed(by: disposeBag)
    }

    func checkMemberAndConnection() {
        authenRepository.checkMemberAndConnection(phoneNumber: AppConfig.shared.phoneNumber.formatVietnamesePhoneNumber(), cif: AppConfig.shared.cif)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let data = res.data
            var isExist = data?.isExisting
            var isConnectedPhone: Bool?
            if let basicInfo = data?.basicInfo {
                AppConfig.shared.accessToken = basicInfo.accessToken ?? ""
                AppConfig.shared.refreshToken = basicInfo.refreshToken ?? ""
                AppConfig.shared.memberCode = basicInfo.memberCode ?? ""
            }

            if let connectedInfo = data?.connectionInfo {
                AppConfig.shared.connectedPhone = connectedInfo.connectedToPhone ?? ""
                AppConfig.shared.connectedMemberCode = connectedInfo.connectedToMemberCode ?? ""
                isConnectedPhone = connectedInfo.isExisting
            }

            if let isExist = isExist, let isConnectedPhone = isConnectedPhone {
                if (isExist && isConnectedPhone) {
                    nextScreenTypeSubj.accept(.existAndConnected)
                } else if (isExist && !isConnectedPhone) {
                    nextScreenTypeSubj.accept(.existAndNotConnected)
                } else if (!isExist && isConnectedPhone) {
                    nextScreenTypeSubj.accept(.notExistAndConnected)
                } else if (!isExist && !isConnectedPhone) {
                    nextScreenTypeSubj.accept(.notExistAndNotConnected)
                }
            }
            self.isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            self.isLoadingSubj.accept(false)
            self.isShowErrorSubj.accept(true)
        }.disposed(by: disposeBag)
    }
}

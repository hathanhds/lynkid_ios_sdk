//
//  OTPViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 28/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class DiamondOTPViewModel {

    let disposeBag = DisposeBag()
    let giftsRepository: GiftsRepository
    let phoneNumber: String
    let sessionId: String
    let quantity: Int
    let giftInfo: GiftInfoItem

    let isLoading = BehaviorRelay(value: false)
    let errorText = BehaviorRelay(value: "")
    let confirmResult = PublishSubject<Result<CreateTransactionItem, APIErrorResponseModel>>()
    let resendResult = PublishSubject<Result<Void, APIErrorResponseModel>>()

    init(data: OTPArguments) {
        self.giftsRepository = data.giftsRepository
        self.phoneNumber = AppConfig.shared.phoneNumber
        self.sessionId = data.sessionId
        self.quantity = data.quantity
        self.giftInfo = data.giftInfo
    }

    func confirmOtpCreateTransaction(otpCode: String) {
        isLoading.accept(true)
        giftsRepository.confirmOtpCreateTransaction(
            sessionId: sessionId,
            otpCode: otpCode)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let transaction = res.data?.items?.first ?? CreateTransactionItem()
            confirmResult.onNext(.success(transaction))
            isLoading.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            if let error = error as? APIErrorResponseModel {
                if (error.code == "Invalid OTP") {
                    errorText.accept(error.message ?? "")
                } else {
                    errorText.accept("")
                }
                confirmResult.onNext(.failure(error))
            } else {
                confirmResult.onNext(.failure(APIErrorResponseModel(message: APIError.somethingWentWrong.rawValue)))
            }
            isLoading.accept(false)
        }.disposed(by: disposeBag)
    }

    func resendOtp() {
        isLoading.accept(true)
        giftsRepository.resendOtp(sessionId: sessionId)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            resendResult.onNext(.success(()))
            isLoading.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            if let error = error as? APIErrorResponseModel {
                resendResult.onNext(.failure(error))
            } else {
                resendResult.onNext(.failure(APIErrorResponseModel(message: APIError.somethingWentWrong.rawValue)))
            }
            isLoading.accept(false)
        }.disposed(by: disposeBag)
    }
}


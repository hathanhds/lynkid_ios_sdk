//
//  TopupConfirmViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/08/2024.
//

import Foundation
import RxSwift
import RxRelay

class TopupConfirmViewModel {


    var isLoading = BehaviorRelay<Bool>(value: false)
    var quantity = BehaviorRelay<Int>(value: 1)


    private let disposeBag = DisposeBag()
    private let giftsRepository: GiftsRepository
    let data: TopupConfirmArgument
    let userPoint = AppUserDefaults.userPoint
    var sessionId: String = ""
    var createTransactionResult = PublishSubject<Result<CreateTransactionResponseModel?, APIErrorResponseModel>>()
    init(giftsRepository: GiftsRepository, data: TopupConfirmArgument) {
        self.giftsRepository = giftsRepository
        self.data = data
    }

    func onPlus(vc: UIViewController) {
        let giftInfor = data.giftInfo.giftInfor
        let giftExchangePrice = giftInfor?.requiredCoin ?? 0

        let currentQuantity = quantity.value
        let expectedQuantity = currentQuantity + 1
        if (userPoint < Double(expectedQuantity) * giftExchangePrice) {
            vc.showToast(ofType: .warning, withMessage: "Số dư điểm LynkiD của bạn không đủ")
        } else {
            quantity.accept(currentQuantity + 1)
        }
    }

    func onMinus() {
        let _quantity = quantity.value
        if (_quantity > 1) {
            quantity.accept(_quantity - 1)
        }
    }

    // 1000: mua mã thẻ, data
    // 1200: nạp thẻ, data
    func onCreateTransaction() {
        isLoading.accept(true)
        sessionId = "LynkID\(Date().currentTimeMillis())"
        let quantity = quantity.value
        let giftExchangePrice = data.giftInfo.giftInfor?.requiredCoin ?? 0
        giftsRepository.createTransaction(request: CreateTransactionRequestModel(
            sessionId: sessionId,
            giftCode: data.giftInfo.giftInfor?.code ?? "",
            totalAmount: quantity * Int(giftExchangePrice),
            quantity: quantity,
            topupInfo: TopupRedeemInfo(
                operation: data.topupPhoneType == .buyCard || data.topupDataType == .buyCard ? 1000 : 1200,
                ownerPhone: data.phoneNumber,
                accountType: data.topupPhoneType?.paidType)
            ))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            createTransactionResult.onNext(.success(res.data))
            isLoading.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            if let error = error as? APIErrorResponseModel {
                self.createTransactionResult.onNext(.failure(error))
            } else {
                self.createTransactionResult.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
            }

            isLoading.accept(false)
        }.disposed(by: disposeBag)
    }

    func getTitleExchange() -> String {
        let topupPhoneNumber = "\(data.contactName) - \(data.phoneNumber)"
        if (data.topupPhoneType == .prePaid || data.topupPhoneType == .postPaid) {
            return "Nạp thành công cho \(topupPhoneNumber)"
        } else if (data.topupDataType == .topup) {
            return "Nạp Data thành công cho \(topupPhoneNumber)"
        } else {
            return "Đổi mã thẻ thành công"
        }
    }


}

struct TopupConfirmArgument {
    var giftInfo: GiftInfoItem
    var brandInfo: TopupBrandItem
    var topupPhoneType: TopupPhoneType?
    var topupDataType: TopupDataType?
    var topupType: TopupType
    var phoneNumber: String
    var contactName: String

    init(giftInfo: GiftInfoItem, brandInfo: TopupBrandItem, topupPhoneType: TopupPhoneType?, topupDataType: TopupDataType?, topupType: TopupType, phoneNumber: String, contactName: String) {
        self.giftInfo = giftInfo
        self.brandInfo = brandInfo
        self.topupPhoneType = topupPhoneType
        self.topupDataType = topupDataType
        self.topupType = topupType
        self.phoneNumber = phoneNumber
        self.contactName = contactName
    }
}

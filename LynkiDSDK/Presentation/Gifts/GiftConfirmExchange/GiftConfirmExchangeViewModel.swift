//
//  GiftConfirmExchangeViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 31/05/2024.
//

import RxSwift
import RxCocoa
import RxRelay

class GiftConfirmExchangeViewModel {
    let disposeBag = DisposeBag()

    private let giftsRepository: GiftsRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>

    }

    struct Output {
        let quantity: BehaviorRelay<Int>
        let isLoading: BehaviorRelay<Bool>
        let createTransactionResult: Observable<Result<CreateTransactionResponseModel?, APIErrorResponseModel>>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let quantitySubj = BehaviorRelay<Int>(value: 1)
    let isLoadingSubj = BehaviorRelay<Bool>(value: false)
    let createTransactionResultSubj = PublishSubject<Result<CreateTransactionResponseModel?, APIErrorResponseModel>>()

    let giftInfo: GiftInfoItem
    let giftExchangePrice: Double!
    let userPoint = AppUserDefaults.userPoint
    var sessionId: String = ""
    let receiverInfo: ReceiverInfoModel?

    init(data: GiftConfirmExchangeArguments) {
        self.giftsRepository = data.giftsRepository
        self.giftInfo = data.giftInfo
        self.giftExchangePrice = data.giftExchangePrice
        self.receiverInfo = data.receiverInfo

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(
            quantity: quantitySubj,
            isLoading: isLoadingSubj,
            createTransactionResult: createTransactionResultSubj.asObservable()
        )

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }

        }.disposed(by: disposeBag)

    }

    func onCreateTransaction() {
        isLoadingSubj.accept(true)
        sessionId = "LynkID\(Date().currentTimeMillis())"
        let quantity = output.quantity.value
        giftsRepository.createTransaction(request: CreateTransactionRequestModel(sessionId: sessionId,
            giftCode: giftInfo.giftInfor?.code ?? "",
            totalAmount: quantity * Int(giftExchangePrice),
            quantity: quantity,
            receiverInfo: receiverInfo))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            createTransactionResultSubj.onNext(.success(res.data))
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            if let error = error as? APIErrorResponseModel {
                self.createTransactionResultSubj.onNext(.failure(error))
            } else {
                self.createTransactionResultSubj.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
            }

            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func onPlus(vc: UIViewController) {
        let giftInfor = giftInfo.giftInfor
        let maxQuantityPerRedemptionOfUser = giftInfor?.maxQuantityPerRedemptionOfUser ?? 0
        let maxAllowedRedemptionOfUser = giftInfor?.maxAllowedRedemptionOfUser ?? 0
        let totalRedeemedOfUser = giftInfor?.totalRedeemedOfUser ?? 0
        let remainingQuantity = giftInfor?.remainingQuantity ?? 0
        let remainingTurn = maxAllowedRedemptionOfUser - totalRedeemedOfUser

        let currentQuantity = output.quantity.value
        let expectedQuantity = currentQuantity + 1
        if (userPoint < Double(expectedQuantity) * giftExchangePrice) {
            vc.showToast(ofType: .warning, withMessage: "Số dư điểm LynkiD của bạn không đủ")
        } else if (maxQuantityPerRedemptionOfUser > 0 && expectedQuantity > maxQuantityPerRedemptionOfUser) {
            vc.showToast(ofType: .warning, withMessage: "Bạn chỉ được đổi tối đa \(maxQuantityPerRedemptionOfUser) quà/ lượt đổi")
        } else if (maxAllowedRedemptionOfUser > 0 && expectedQuantity > remainingTurn) {
            vc.showToast(ofType: .warning, withMessage: "Bạn chỉ được đổi tối đa \(remainingTurn) quà")
        } else if (expectedQuantity > remainingQuantity) {
            vc.showToast(ofType: .warning, withMessage: "Yêu cầu đổi quà vượt quá số lượng quà trong kho")
        } else {
            quantitySubj.accept(currentQuantity + 1)
        }
    }

    func onMinus() {
        let quantity = output.quantity.value
        if (quantity > 1) {
            quantitySubj.accept(quantity - 1)
        }
    }
}

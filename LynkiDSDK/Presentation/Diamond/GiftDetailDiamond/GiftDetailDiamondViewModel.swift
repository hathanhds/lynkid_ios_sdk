//
//  GiftDetailViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

class GiftDetailDiamondViewModel: ViewModelType {
    let disposeBag = DisposeBag()

    private let giftsRepository: GiftsRepository
    private let userRepository: UserRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let getMemberVpbankInforResult: Observable<Result<Bool, APIErrorResponseModel>>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let giftInfo: BehaviorRelay<GiftInfoItem?>
        let isShowFlashSaleInfo: BehaviorRelay<Bool>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()
    let getMemberVpbankInforResultSubj = PublishSubject<Result<Bool, APIErrorResponseModel>>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let giftInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)
    let isShowFlashSaleInfoSubj = BehaviorRelay(value: false)

    let giftId: String

    init(giftsRepository: GiftsRepository, userRepository: UserRepository, giftInfo: GiftInfoItem?, giftId: String) {
        self.giftsRepository = giftsRepository
        self.userRepository = userRepository
        self.giftId = giftId

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver(),
            getMemberVpbankInforResult: getMemberVpbankInforResultSubj)
        self.output = Output(isLoading: isLoadingSubj,
            giftInfo: giftInfoSubj,
            isShowFlashSaleInfo: isShowFlashSaleInfoSubj)

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            if let giftInfo = giftInfo {
                giftInfoSubj.accept(giftInfo)
            }
            self.getGiftDetail()
        }.disposed(by: disposeBag)
    }

    func getGiftDetail(loadingState: LoadingState = .loading) {
        isLoadingSubj.accept(true)
        giftsRepository.getGiftDetail(giftId: giftId)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.data {
                giftInfoSubj.accept(data)
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getMemberVpbankInfor() {
        isLoadingSubj.accept(true)
        userRepository.getMemberVpbankInfor()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let memberInfor = res.memberInfor, let segment = memberInfor.segment?.lowercased(), segment == "af" {
                getMemberVpbankInforResultSubj.onNext(.success(true))
            } else {
                getMemberVpbankInforResultSubj.onNext(.success(false))
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
            if let error = error as? APIErrorResponseModel {
                self.getMemberVpbankInforResultSubj.onNext(.failure(error))
            } else {
                self.getMemberVpbankInforResultSubj.onNext(.failure(APIErrorResponseModel(message: error.localizedDescription)))
            }
        }.disposed(by: disposeBag)
    }
}

extension GiftDetailDiamondViewModel {

    func getDisplayDateString(expiredDate: String?) -> String? {
        if let expiredDate = expiredDate, !expiredDate.isEmpty {
            let _expiredDate = expiredDate.lowercased()
            if (_expiredDate.contains("-") && _expiredDate.contains(":")) {
                return "Hạn sử dụng: \(UtilHelper.formatDate(date: expiredDate))"
            } else if _expiredDate.contains("Tối thiểu") {
                return "Ưu đãi \(_expiredDate) kể từ ngày đổi"
            } else {
                return "Ưu đãi trong \(_expiredDate) kể từ ngày đổi"
            }
        }
        return nil
    }

    func getEarnMoreCoinString() -> String {
        var earnMoreCoin: Double = getEarnMoreCoin()
        if earnMoreCoin > 0 {
            return "Tích thêm \(earnMoreCoin.formatter()) điểm nữa để đổi ưu đãi nhé."
        }
        return ""
    }

    func getEarnMoreCoin() -> Double {
        let giftInfor = output.giftInfo.value?.giftInfor
        let requiredCoin = giftInfor?.requiredCoin ?? 0
        let fullPrice = giftInfor?.fullPrice ?? 0
        let userPoint = AppUserDefaults.userPoint
        return requiredCoin - userPoint
    }

    func getRemaningTurnExchange() -> String {
        let giftInfor = output.giftInfo.value?.giftInfor
        let maxAllowedRedemptionOfUser = giftInfor?.maxAllowedRedemptionOfUser ?? 0
        let maxQuantityPerRedemptionOfUser = giftInfor?.maxQuantityPerRedemptionOfUser ?? 0
        let totalRedemptionOfUser = giftInfor?.totalRedeemedOfUser ?? 0
        let remainingQuantity = maxAllowedRedemptionOfUser - totalRedemptionOfUser
        if (maxAllowedRedemptionOfUser != 0 &&
                maxQuantityPerRedemptionOfUser == 0) {
            return "Bạn còn \(remainingQuantity)/\(maxAllowedRedemptionOfUser) lượt đổi"
        } else if (maxAllowedRedemptionOfUser != 0 &&
                maxQuantityPerRedemptionOfUser != 0) {
            return "Bạn còn \(remainingQuantity)/\(maxAllowedRedemptionOfUser) lượt đổi. Tối đa \(maxQuantityPerRedemptionOfUser) quà/lượt đổi"
        }
        return ""
    }

    func getTitleButton() -> String {
        return getDisplayPrice() == 0 ? "Lấy code" : "Đổi ngay"
    }

    func getDisplayPrice() -> Double {
        let giftInfor = output.giftInfo.value?.giftInfor
        let giftDiscountInfor = output.giftInfo.value?.giftDiscountInfor
        let requiredCoin = giftInfor?.requiredCoin ?? 0
        let salePrice = giftDiscountInfor?.salePrice ?? 0
        let displayPrice = output.isShowFlashSaleInfo.value ? salePrice : requiredCoin
        return displayPrice
    }

    func checkEnableButton() -> Bool {
        let giftInfor = output.giftInfo.value?.giftInfor
        let maxAllowedRedemptionOfUser = giftInfor?.maxAllowedRedemptionOfUser ?? 0
        let totalRedemptionOfUser = giftInfor?.totalRedeemedOfUser ?? 0
        let remainingQuantity = maxAllowedRedemptionOfUser - totalRedemptionOfUser
        if (remainingQuantity <= 0 && maxAllowedRedemptionOfUser > 0 || !getEarnMoreCoinString().isEmpty) {
            return false
        }
        return true
    }
}

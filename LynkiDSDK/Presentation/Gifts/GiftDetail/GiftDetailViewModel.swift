//
//  GiftDetailViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

class GiftDetailViewModel: ViewModelType {
    let disposeBag = DisposeBag()

    private let giftsRepository: GiftsRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let giftInfo: BehaviorRelay<GiftInfoItem?>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let giftInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)

    let giftId: String

    init(giftsRepository: GiftsRepository, giftInfo: GiftInfoItem? = nil, giftId: String) {
        self.giftsRepository = giftsRepository
        self.giftId = giftId

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj,
            giftInfo: giftInfoSubj)

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            giftInfoSubj.accept(giftInfo)
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

}

extension GiftDetailViewModel {

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

    func getEarnMoreCoin() -> Double {
        var earnMoreCoin: Double = 0
        if (FlashSale.shared.isShowFlashSale) {
            earnMoreCoin = getEarnMoreCoinFlashSale()
        } else {
            let giftInfor = output.giftInfo.value?.giftInfor
            let requiredCoin = giftInfor?.requiredCoin ?? 0
            let userPoint = AppUserDefaults.userPoint
            earnMoreCoin = requiredCoin - userPoint
        }
        return earnMoreCoin
    }

    func getEarnMoreCoinFlashSale() -> Double {
        let giftDiscountInfor = output.giftInfo.value?.giftDiscountInfor
        let salePrice = giftDiscountInfor?.salePrice ?? 0
        let userPoint = AppUserDefaults.userPoint
        return salePrice - userPoint
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
        let displayPrice = FlashSale.shared.isShowFlashSale ? salePrice : requiredCoin
        return displayPrice
    }

    func checkEnableButton() -> Bool {
        let giftInfor = output.giftInfo.value?.giftInfor
        let maxAllowedRedemptionOfUser = giftInfor?.maxAllowedRedemptionOfUser ?? 0
        let totalRedemptionOfUser = giftInfor?.totalRedeemedOfUser ?? 0
        let remainingQuantity = maxAllowedRedemptionOfUser - totalRedemptionOfUser
        if (remainingQuantity <= 0 && maxAllowedRedemptionOfUser > 0 || getEarnMoreCoin() > 0) {
            return false
        }
        return true
    }
}

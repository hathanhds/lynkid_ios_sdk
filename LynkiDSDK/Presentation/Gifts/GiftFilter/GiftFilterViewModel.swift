//
//  GiftFilterViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 06/03/2024.
//

import Foundation
import RxSwift
import RxCocoa


class GiftFilterViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    private let giftsRepository: GiftsRepository

    typealias ApplyFilterActionType = ((_ filterModel: GiftFilterModel?) -> Void)

    struct Input {
        let onApplyFilter: AnyObserver<Void>
        let onResetFilter: AnyObserver<Void>
        let onSelectRangePrice: AnyObserver<RangeCoin?>
        let onEdittingFromCoin: AnyObserver<String?>
        let onEdittingToCoin: AnyObserver<String?>
        let onSelectCate: AnyObserver<OptionModel>
        let onSelectGiftType: AnyObserver<OptionModel>
        let onSelectLocation: AnyObserver<OptionModel>
    }

    struct Output {
        let fromCoin: BehaviorRelay<Double?>
        let toCoin: BehaviorRelay<Double?>
        let isSuitablePrice: BehaviorRelay<Bool>
        let selectedRangePrice: BehaviorRelay<RangeCoin?>
        let selectedCates: BehaviorRelay<[OptionModel]>
        let selectedGiftType: BehaviorRelay<OptionModel?>
        let selectedLocations: BehaviorRelay<[OptionModel]>
        let isLoadingGiftCates: BehaviorRelay<Bool>
        let giftCates: BehaviorRelay<[GiftCategory]>
    }

    let input: Input
    let onApplyFilterSubj = PublishSubject<Void>()
    let onResetFilterSubj = PublishSubject<Void>()
    let onSelectRangePriceSubj = PublishSubject<RangeCoin?>()
    let onEdittingFromCoinSubj = PublishSubject<String?>()
    let onEdittingToCoinSubj = PublishSubject<String?>()
    let onSelectCateSubj = PublishSubject<OptionModel>()
    let onSelectGiftTypeSubj = PublishSubject<OptionModel>()
    let onSelectLocationSubj = PublishSubject<OptionModel>()

    let output: Output
    let fromCoinSubj = BehaviorRelay<Double?>(value: nil)
    let toCointSubj = BehaviorRelay<Double?>(value: nil)
    let isSuitablePriceSubj = BehaviorRelay<Bool>(value: false)
    let selectedRangePriceSubj = BehaviorRelay<RangeCoin?>(value: nil)
    let selectedCatesSubj = BehaviorRelay<[OptionModel]>(value: [])
    let selectedGiftTypeSubj = BehaviorRelay<OptionModel?>(value: nil)
    let selectedLocationsSubj = BehaviorRelay<[OptionModel]>(value: [])
    let isLoadingGiftCatesSubj = BehaviorRelay(value: false)
    let giftCatesSubj = BehaviorRelay<[GiftCategory]>(value: [])

    let listPrice = RangeCoin.defaultRangeCoinList
    let isShowCates: Bool

    init(giftsRepository: GiftsRepository, filterModel: GiftFilterModel?, applyFilterAction: ApplyFilterActionType?, isShowCates: Bool = false) {
        self.isShowCates = isShowCates
        self.giftsRepository = giftsRepository

        self.input = Input(
            onApplyFilter: onApplyFilterSubj.asObserver(),
            onResetFilter: onResetFilterSubj.asObserver(),
            onSelectRangePrice: onSelectRangePriceSubj.asObserver(),
            onEdittingFromCoin: onEdittingFromCoinSubj.asObserver(),
            onEdittingToCoin: onEdittingToCoinSubj.asObserver(),
            onSelectCate: onSelectCateSubj.asObserver(),
            onSelectGiftType: onSelectGiftTypeSubj.asObserver(),
            onSelectLocation: onSelectLocationSubj.asObserver()
        )
        self.output = Output(
            fromCoin: fromCoinSubj,
            toCoin: toCointSubj,
            isSuitablePrice: isSuitablePriceSubj,
            selectedRangePrice: selectedRangePriceSubj,
            selectedCates: selectedCatesSubj,
            selectedGiftType: selectedGiftTypeSubj,
            selectedLocations: selectedLocationsSubj,
            isLoadingGiftCates: isLoadingGiftCatesSubj,
            giftCates: giftCatesSubj
        )
        setupFilterModel(filterModel)
        handleInput(applyFilterAction)

        if (isShowCates) {
            let cates = AppUserDefaults.categories
            if !cates.isEmpty {
                giftCatesSubj.accept(cates)
            } else {
                getListCate()
            }
        }
    }

    func setupFilterModel(_ filterModel: GiftFilterModel?) {
        fromCoinSubj.accept(filterModel?.fromCoin)
        toCointSubj.accept(filterModel?.toCoin)
        isSuitablePriceSubj.accept((filterModel?.isSuitablePrice ?? false))
        selectedRangePriceSubj.accept(filterModel?.selectedRange)
        selectedCatesSubj.accept(filterModel?.selectedCates ?? [])
        selectedGiftTypeSubj.accept(filterModel?.giftType)
        selectedLocationsSubj.accept(filterModel?.locations ?? [])
    }

    func handleInput(_ applyFilterAction: ApplyFilterActionType?) {
        self.onApplyFilterSubj
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            applyFilterAction?(getFilterModel())
        })
            .disposed(by: self.disposeBag)

        self.onResetFilterSubj
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            fromCoinSubj.accept(nil)
            toCointSubj.accept(nil)
            isSuitablePriceSubj.accept(false)
            selectedRangePriceSubj.accept(nil)
            selectedCatesSubj.accept([])
            selectedGiftTypeSubj.accept(nil)
            selectedLocationsSubj.accept([])

        })
            .disposed(by: self.disposeBag)

        self.onSelectRangePriceSubj
            .subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            let selectedRangePrice = self.output.selectedRangePrice.value
            if (selectedRangePrice == option) {
                selectedRangePriceSubj.accept(nil)
                fromCoinSubj.accept(nil)
                toCointSubj.accept(nil)
            } else {
                selectedRangePriceSubj.accept(option)
                fromCoinSubj.accept(option?.fromCoin)
                toCointSubj.accept(option?.toCoin)
            }
        })
            .disposed(by: self.disposeBag)

        self.onEdittingFromCoinSubj
            .subscribe(onNext: { [weak self] fromCoin in
            guard let self = self else { return }
            var range: RangeCoin?
            let currentToCoin = output.toCoin.value
            if let fromCoin = fromCoin {
                let price = Double(fromCoin)
                for v in listPrice {
                    if v.fromCoin == price && v.toCoin == currentToCoin {
                        range = v
                    }
                }
                fromCoinSubj.accept(price)
            } else {
                fromCoinSubj.accept(nil)
            }
            selectedRangePriceSubj.accept(range)

        })
            .disposed(by: self.disposeBag)

        self.onEdittingToCoinSubj
            .subscribe(onNext: { [weak self] toCoin in
            guard let self = self else { return }
            var range: RangeCoin?
            let currentFromCoin = output.fromCoin.value
            if let toCoin = toCoin {
                let price = Double(toCoin)
                for v in listPrice {
                    if v.toCoin == price && v.fromCoin == currentFromCoin {
                        range = v
                    }
                }
                toCointSubj.accept(price)
            } else {
                toCointSubj.accept(nil)
            }
            selectedRangePriceSubj.accept(range)
        })
            .disposed(by: self.disposeBag)

        self.onSelectCateSubj
            .subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            var selectedCates = self.output.selectedCates.value
            if selectedCates.contains(option) {
                selectedCatesSubj.accept(selectedCates.filter { $0 != option })
            } else {
                selectedCates.append(option)
                selectedCatesSubj.accept(selectedCates)
            }
        })
            .disposed(by: self.disposeBag)

        self.onSelectGiftTypeSubj
            .subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            let selectedGiftType = self.output.selectedGiftType.value
            selectedGiftTypeSubj.accept(selectedGiftType == option ? nil : option)
        })
            .disposed(by: self.disposeBag)

        self.onSelectLocationSubj
            .subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            var selectedLocations = self.output.selectedLocations.value
            if selectedLocations.contains(option) {
                selectedLocationsSubj.accept(selectedLocations.filter { $0 != option })
            } else {
                selectedLocations.append(option)
                selectedLocationsSubj.accept(selectedLocations)
            }
        })
            .disposed(by: self.disposeBag)
    }

    func isFilter() -> Bool {
        if output.fromCoin.value != nil
            || output.toCoin.value != nil
            || output.isSuitablePrice.value
            || !output.selectedCates.value.isEmpty
            || output.selectedGiftType.value != nil
            || output.selectedRangePrice.value != nil
            || !output.selectedLocations.value.isEmpty {
            return true
        }
        return false
    }

    func getFilterModel() -> GiftFilterModel? {
        if isFilter() {
            return GiftFilterModel(
                giftType: selectedGiftTypeSubj.value,
                locations: selectedLocationsSubj.value,
                fromCoin: fromCoinSubj.value,
                toCoin: toCointSubj.value,
                isSuitablePrice: isSuitablePriceSubj.value,
                selectedRange: selectedRangePriceSubj.value,
                selectedCates: selectedCatesSubj.value
            )
        } else {
            return nil
        }
    }

    func getListCate() {
        isLoadingGiftCatesSubj.accept(true)
        dispatchGroup.enter()
        giftsRepository.getListGiftCate()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let cates = res.data?.row2 ?? []
            giftCatesSubj.accept(cates)
            AppUserDefaults.categories = cates
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGiftCatesSubj.accept(false)
            dispatchGroup.leave()
        }.disposed(by: disposeBag)
    }
}

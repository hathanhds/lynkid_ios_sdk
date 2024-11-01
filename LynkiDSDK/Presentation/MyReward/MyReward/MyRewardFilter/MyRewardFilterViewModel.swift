//
//  MyRewardFilterViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/05/2024.
//

import Foundation
import RxSwift
import RxCocoa


class MyRewardFilterViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()

    typealias ApplyFilterActionType = ((_ filterModel: MyrewardFilterModel?) -> Void)

    struct Input {
        let onApplyFilter: AnyObserver<Void>
        let onResetFilter: AnyObserver<Void>
        let onSelectGiftType: AnyObserver<OptionModel>
        let onSelectStatus: AnyObserver<OptionModel>
        let onSelectPresentType: AnyObserver<OptionModel>
    }

    struct Output {
        let selectedGiftType: BehaviorRelay<OptionModel?>
        let selectedStatus: BehaviorRelay<OptionModel?>
        let selectedPresentType: BehaviorRelay<OptionModel?>
    }

    let input: Input
    let onApplyFilterSubj = PublishSubject<Void>()
    let onResetFilterSubj = PublishSubject<Void>()
    let onSelectGiftTypeSubj = PublishSubject<OptionModel>()
    let onSelectStatusSubj = PublishSubject<OptionModel>()
    let onSelectPresentTypeSubj = PublishSubject<OptionModel>()

    let output: Output
    let selectedGiftTypeSubj = BehaviorRelay<OptionModel?>(value: nil)
    let selectedStatusSubj = BehaviorRelay<OptionModel?>(value: nil)
    let selectedPresentTypeSubj = BehaviorRelay<OptionModel?>(value: nil)

    var myRewardType: MyRewardType

    init(filterModel: MyrewardFilterModel?, applyFilterAction: ApplyFilterActionType?, myRewardType: MyRewardType) {
        self.input = Input(
            onApplyFilter: onApplyFilterSubj.asObserver(),
            onResetFilter: onResetFilterSubj.asObserver(),
            onSelectGiftType: onSelectGiftTypeSubj.asObserver(),
            onSelectStatus: onSelectStatusSubj.asObserver(),
            onSelectPresentType: onSelectPresentTypeSubj.asObserver()
        )
        self.output = Output(
            selectedGiftType: selectedGiftTypeSubj,
            selectedStatus: selectedStatusSubj,
            selectedPresentType: selectedPresentTypeSubj
        )

        self.myRewardType = myRewardType
        self.setupFilterModel(filterModel)
        self.handleInput(applyFilterAction)
    }

    func setupFilterModel(_ filterModel: MyrewardFilterModel?) {
        selectedGiftTypeSubj.accept(filterModel?.giftType)
        selectedStatusSubj.accept(filterModel?.status)
        selectedPresentTypeSubj.accept(filterModel?.presentType)
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
            selectedGiftTypeSubj.accept(nil)
            selectedStatusSubj.accept(nil)
            selectedPresentTypeSubj.accept(nil)
        })
            .disposed(by: self.disposeBag)

        self.onSelectGiftTypeSubj
            .subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            let selectedGiftType = self.output.selectedGiftType.value
            selectedGiftTypeSubj.accept(selectedGiftType == option ? nil : option)
        })
            .disposed(by: self.disposeBag)

        self.onSelectStatusSubj
            .subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            let selectedStatus = self.output.selectedStatus.value
            selectedStatusSubj.accept(selectedStatus == option ? nil : option)
        })
            .disposed(by: self.disposeBag)

        self.onSelectPresentTypeSubj
            .subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            let selectPresentType = self.output.selectedPresentType.value
            selectedPresentTypeSubj.accept(selectPresentType == option ? nil : option)
        })
            .disposed(by: self.disposeBag)
    }

    func isFilter() -> Bool {
        if output.selectedGiftType.value != nil
            || output.selectedStatus.value != nil
            || output.selectedPresentType.value != nil {
            return true
        }
        return false
    }

    func getFilterModel() -> MyrewardFilterModel? {
        if isFilter() {
            return MyrewardFilterModel(giftType: selectedGiftTypeSubj.value,
                status: selectedStatusSubj.value,
                presentType: selectedPresentTypeSubj.value
            )
        } else {
            return nil
        }
    }
    
    func getListGiftType() -> [OptionModel] {
        return MyrewardFilterModel.giftTypes
    }

    func getListStatus() -> [OptionModel] {
        if (self.myRewardType == MyRewardType.myOwnedReward) {
            return MyrewardFilterModel.MyOwnedReward.status
        }
        return MyrewardFilterModel.MyUsedReward.status
    }

    func getListPresent() -> [OptionModel] {
        if (self.myRewardType == MyRewardType.myOwnedReward) {
            return MyrewardFilterModel.MyOwnedReward.presentTypes
        }
        return MyrewardFilterModel.MyUsedReward.presentTypes
    }
}

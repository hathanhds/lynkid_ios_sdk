//
//  EgiftRewardDetailViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 17/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class PhysicalRewardDetailViewModel: ViewModelType {
    let disposeBag = DisposeBag()

    let dispatchGroup = DispatchGroup()

    private let myRewardRepository: MyrewardRepository
    private let userRepository: UserRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>

    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let giftInfo: BehaviorRelay<GiftInfoItem?>
        let listProgress: BehaviorRelay<[PhysicalRewardTransactionModel]>
        let isLoadingLocation: BehaviorRelay<Bool>
        let shipInfo: BehaviorRelay<PhysicalRewardShipModel?>
        let fullLocation: BehaviorRelay<String?>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let giftInfoSubj = BehaviorRelay<GiftInfoItem?>(value: nil)
    let listProgressSubj = BehaviorRelay<[PhysicalRewardTransactionModel]>(value: [])
    let isLoadingLocationSubj = BehaviorRelay(value: false)
    let shipInfoSubj = BehaviorRelay<PhysicalRewardShipModel?>(value: nil)
    let fullLocationSubj = BehaviorRelay<String?>(value: nil)

    let giftTransactionCode: String

    init(myRewardRepository: MyrewardRepository, userRepository: UserRepository, giftTransactionCode: String, giftInfo: GiftInfoItem? = nil) {
        self.myRewardRepository = myRewardRepository
        self.userRepository = userRepository
        self.giftTransactionCode = giftTransactionCode

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(
            isLoading: isLoadingSubj,
            giftInfo: giftInfoSubj,
            listProgress: listProgressSubj,
            isLoadingLocation: isLoadingLocationSubj,
            shipInfo: shipInfoSubj,
            fullLocation: fullLocationSubj
        )

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            if (!giftTransactionCode.isEmpty) {
                self.getMyRewardDetail()
            } else if (giftInfo != nil) {
                giftInfoSubj.accept(giftInfo)
                if let giftTransaction = giftInfo?.giftTransaction {
                    listProgressSubj.accept(getProgressItems(status: giftTransaction.status ?? ""))
                    handleShipInfo(giftTransaction: giftTransaction)
                }

            }
        }.disposed(by: disposeBag)
    }

    func getMyRewardDetail(loadingState: LoadingState = .loading) {
        isLoadingSubj.accept(true)
        myRewardRepository.getMyRewardDetail(giftTransactionCode: self.giftTransactionCode)
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.result?.items?.first {
                giftInfoSubj.accept(data)
                if let giftTransaction = data.giftTransaction {
                    listProgressSubj.accept(getProgressItems(status: giftTransaction.status ?? ""))
                    handleShipInfo(giftTransaction: giftTransaction)
                }
            }
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)

    }

    func getDetailLocation(type: LocationType, fatherId: String? = nil, locationId: String, onSuccess: @escaping (_ locationName: String) -> Void, onComplete: @escaping () -> Void) {
        userRepository.getLocation(request: LocationRequestModel(parentCodeFilter: fatherId, levelFilter: type.rawValue, vendorType: "LinkID"))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let items = res.result?.items
            let location = items?.first { $0.code == locationId }
            if let locationName = location?.name {
                onSuccess(locationName)
            }
            onComplete()
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            onComplete()
        }.disposed(by: disposeBag)
    }

    func getFullLocation(cityId: String, districtId: String, wardId: String, shipAddress: String?) {
        var cityName = ""
        var districtName = ""
        var wardname = ""

        output.isLoadingLocation.accept(true)
        dispatchGroup.enter()
        getDetailLocation(type: .city,
            locationId: cityId) { [weak self] locationName in
            guard let self = self else { return }
            cityName = locationName
        } onComplete: {
            self.dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getDetailLocation(type: .district,
            fatherId: cityId,
            locationId: districtId) { [weak self] locationName in
            districtName = locationName
            guard let self = self else { return }
        } onComplete: {
            self.dispatchGroup.leave()
        }

        dispatchGroup.enter()
        getDetailLocation(type: .ward,
            fatherId: districtId,
            locationId: wardId) { [weak self] locationName in
            guard let self = self else { return }
            wardname = locationName
        } onComplete: {
            self.dispatchGroup.leave()
        }

        var listAddress: [String] = []
        dispatchGroup.notify(queue: .main) {
            self.output.isLoadingLocation.accept(false)
            if !cityName.isEmpty {
                listAddress.insert(cityName, at: 0)
            }
            if !districtName.isEmpty {
                listAddress.insert(districtName, at: 0)
            }
            if !wardname.isEmpty {
                listAddress.insert(wardname, at: 0)
            }

            if let shipAddress = shipAddress, !shipAddress.isEmpty {
                listAddress.insert(shipAddress, at: 0)
            }

            let fullAddress = listAddress.joined(separator: ", ")
            if !fullAddress.isEmpty {
                self.output.fullLocation.accept(fullAddress)
            }
        }
    }

}

extension PhysicalRewardDetailViewModel {
    func handleShipInfo(giftTransaction: GiftTransaction) {
        if let description = giftTransaction.description, let jsonData = description.data(using: .utf8), let json = try? jsonData.decoded(type: ShipInfoResponseModel.self) {
            var rewardShipInfo = PhysicalRewardShipModel()
            if let fullName = json.fullname, !fullName.isEmpty {
                rewardShipInfo = rewardShipInfo.copyWith(fullName: fullName.trim())
            }
            if let phone = json.phone, !phone.isEmpty {
                rewardShipInfo = rewardShipInfo.copyWith(phoneNumber: phone.trim())
            }
            if let note = json.note, !note.isEmpty {
                rewardShipInfo = rewardShipInfo.copyWith(note: note.trim())
            }
            if let fullLocation = json.fullLocation, !fullLocation.isEmpty {
                //rewardShipInfo = rewardShipInfo.copyWith(address: fullLocation.trim())
                output.fullLocation.accept(fullLocation)
            } else {
                var cityId = ""
                var districtId = ""
                var wardId = ""
                if let _cityId = json.cityId, !_cityId.isEmpty {
                    cityId = _cityId
                }
                if let _districtId = json.districtId, !_districtId.isEmpty {
                    districtId = _districtId
                }
                if let _wardId = json.wardId, !_wardId.isEmpty {
                    wardId = _wardId
                }
                getFullLocation(cityId: cityId, districtId: districtId, wardId: wardId, shipAddress: json.shipAddress)
            }
            shipInfoSubj.accept(rewardShipInfo)
        }
    }
}

extension PhysicalRewardDetailViewModel {
    func caculateTicketPosition() -> CGFloat {
        let giftName = output.giftInfo.value?.giftTransaction?.giftName ?? ""
        let imageHeight = 171.0
        let titleHeight = UtilHelper.heightForLabel(text: giftName, font: .f18s!, width: UtilHelper.screenWidth - 64)
        let quantityHeight = 16.0
        let space = CGFloat(12 + 4 + 18)
        return CGFloat(imageHeight + titleHeight + quantityHeight + space)
    }
}

extension PhysicalRewardDetailViewModel {
    func getProgressItems(status: String) -> [PhysicalRewardTransactionModel] {
        let statusFormater = PhysicalRewardStatus.allCases.first { $0.rawValue.lowercased() == status.lowercased() }
        let progressIndex = statusFormater?.progressInfo.progressIndex ?? 0;
        let progress1 = [
            PhysicalRewardTransactionModel(
                title: "Đang xử lý",
                stepNumber: 1,
                isCurrentStep: progressIndex == 1,
                isLeftLineActive: progressIndex >= 1,
                isRightLineActive: progressIndex > 1),
            PhysicalRewardTransactionModel(
                title: "Đang giao hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 2,
                isLeftLineActive: progressIndex >= 2,
                isRightLineActive: progressIndex > 2),
            PhysicalRewardTransactionModel(
                title: "Đã giao hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 3,
                isLeftLineActive: progressIndex == 3,
                isRightLineActive: progressIndex == 3),
        ];

        let progress2 = [
            PhysicalRewardTransactionModel(
                title: "Đang xử lý",
                stepNumber: 1,
                isCurrentStep: progressIndex == 1,
                isLeftLineActive: progressIndex >= 1,
                isRightLineActive: progressIndex > 1),
            PhysicalRewardTransactionModel(
                title: "Đã huỷ",
                stepNumber: 2,
                isCurrentStep: progressIndex == 2,
                isLeftLineActive: progressIndex == 2,
                isRightLineActive: progressIndex == 2),
        ];

        let progress3 = [
            PhysicalRewardTransactionModel(
                title: "Đang xử lý",
                stepNumber: 1,
                isCurrentStep: progressIndex == 1,
                isLeftLineActive: progressIndex >= 1,
                isRightLineActive: progressIndex > 1),
            PhysicalRewardTransactionModel(
                title: "Đang giao hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 2,
                isLeftLineActive: progressIndex >= 2,
                isRightLineActive: progressIndex > 2),
            PhysicalRewardTransactionModel(
                title: "Vận chuyển trả hàng",
                stepNumber: 2,
                isCurrentStep: progressIndex == 3,
                isLeftLineActive: progressIndex >= 3,
                isRightLineActive: progressIndex > 3),
            PhysicalRewardTransactionModel(
                title: "Đã huỷ",
                stepNumber: 4,
                isCurrentStep: progressIndex == 4,
                isLeftLineActive: progressIndex == 4,
                isRightLineActive: progressIndex == 4),
        ];

        switch (statusFormater?.progressInfo.progressNumber) {
        case 1:
            return progress1;
        case 2:
            return progress2;
        case 3:
            return progress3;
        default:
            return [];
        }
    }
}

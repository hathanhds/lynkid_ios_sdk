//
//  PhysicalShippingViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class DiamondPhysicalShippingViewModel: ViewModelType {
    let disposeBag = DisposeBag()

    private let userRepository: UserRepository

    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }

    struct Output {
        let isLoading: BehaviorRelay<Bool>
        let isEnableButton: BehaviorRelay<Bool>
        let nameErrorText: BehaviorRelay<String?>
        let phoneErrorText: BehaviorRelay<String?>
        let nameInput: BehaviorRelay<String?>
        let phoneInput: BehaviorRelay<String?>

        let selectedCity: BehaviorRelay<LocationModel?>
        let cities: BehaviorRelay<[LocationModel]>
        let isCitiesLoading: BehaviorRelay<Bool>

        let selectedDistrict: BehaviorRelay<LocationModel?>
        let districts: BehaviorRelay<[LocationModel]>
        let isDistrictLoading: BehaviorRelay<Bool>

        let selectedWard: BehaviorRelay<LocationModel?>
        let wards: BehaviorRelay<[LocationModel]>
        let isWardsLoading: BehaviorRelay<Bool>

        let detailAddressInput: BehaviorRelay<String?>
        let noteInput: BehaviorRelay<String?>
    }

    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
    let isLoadingSubj = BehaviorRelay(value: false)
    let isEnableButtonSubj = BehaviorRelay(value: false)
    let nameErrorTextSubj = BehaviorRelay<String?>(value: nil)
    let phoneErrorTextSubj = BehaviorRelay<String?>(value: nil)
    let nameInputSubj = BehaviorRelay<String?>(value: nil)
    let phoneInputSubj = BehaviorRelay<String?>(value: nil)

    let selectedCitySubj = BehaviorRelay<LocationModel?>(value: nil)
    let citiesSubj = BehaviorRelay<[LocationModel]>(value: [])
    let isCitiesLoadingSubj = BehaviorRelay<Bool>(value: false)

    let selectedDistrictSubj = BehaviorRelay<LocationModel?>(value: nil)
    let districtsSubj = BehaviorRelay<[LocationModel]>(value: [])
    let isDistrictLoadingSubj = BehaviorRelay<Bool>(value: false)

    let selectedWardSubj = BehaviorRelay<LocationModel?>(value: nil)
    let wardsSubj = BehaviorRelay<[LocationModel]>(value: [])
    let isWardsLoadingSubj = BehaviorRelay<Bool>(value: false)

    let detailAddressInputSubj = BehaviorRelay<String?>(value: nil)
    let noteInputSubj = BehaviorRelay<String?>(value: nil)

    // Params
    let giftInfo: GiftInfoItem
    let giftExchangePrice: Double

    init(userRepository: UserRepository,
        giftInfo: GiftInfoItem,
        giftExchangePrice: Double,
        receiverInfoModel: ReceiverInfoModel? = nil
    ) {
        self.userRepository = userRepository
        self.giftInfo = giftInfo
        self.giftExchangePrice = giftExchangePrice

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output(isLoading: isLoadingSubj,
            isEnableButton: isEnableButtonSubj,
            nameErrorText: nameErrorTextSubj,
            phoneErrorText: phoneErrorTextSubj,
            nameInput: nameInputSubj,
            phoneInput: phoneInputSubj,
            selectedCity: selectedCitySubj,
            cities: citiesSubj,
            isCitiesLoading: isCitiesLoadingSubj,
            selectedDistrict: selectedDistrictSubj,
            districts: districtsSubj,
            isDistrictLoading: isDistrictLoadingSubj,
            selectedWard: selectedWardSubj,
            wards: wardsSubj,
            isWardsLoading: isWardsLoadingSubj,
            detailAddressInput: detailAddressInputSubj,
            noteInput: noteInputSubj)

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
            // Nếu đi từ nút chỉnh sửa màn xác nhận
            // Hiển thị thông tin đã điền trước đó
            if let data = receiverInfoModel {
                nameInputSubj.accept(data.name)
                phoneInputSubj.accept(data.phoneNumber)
                onSelectedCity(location: data.city)
                onSelectedDistrict(location: data.district)
                onSelectedWard(location: data.ward)
                detailAddressInputSubj.accept(data.detailAddress)
                noteInputSubj.accept(data.note)
            } else {
                getMemberView()
            }
            checkEnableButton()
            getListLocation(type: .city)
        }.disposed(by: disposeBag)
    }

    func getListLocation(type: LocationType, fatherId: String? = nil, locationId: String? = nil) {
        switch type {
        case .city:
            isCitiesLoadingSubj.accept(true)
        case .district:
            isDistrictLoadingSubj.accept(true)
        case .ward:
            isWardsLoadingSubj.accept(true)
        }
        userRepository.getLocation(request: LocationRequestModel(parentCodeFilter: fatherId, levelFilter: type.rawValue, vendorType: "LinkID"))
            .subscribe { [weak self] res in
            guard let self = self else { return }
            let locations = res.result?.items ?? []
            switch type {
            case .city:
                citiesSubj.accept(locations)
                isCitiesLoadingSubj.accept(false)
            case .district:
                districtsSubj.accept(locations)
                isDistrictLoadingSubj.accept(false)
            case .ward:
                wardsSubj.accept(locations)
                isWardsLoadingSubj.accept(false)
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isCitiesLoadingSubj.accept(false)
            isDistrictLoadingSubj.accept(false)
            isWardsLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }

    func getMemberView() {
        isLoadingSubj.accept(true)
        userRepository.getMemberView()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.data {
                nameInputSubj.accept(data.name)
                phoneInputSubj.accept(data.phoneNumber)
                onSelectedCity(location: data.city)
                onSelectedDistrict(location: data.district)
                onSelectedWard(location: data.ward)
                detailAddressInputSubj.accept(data.streetDetail)
                noteInputSubj.accept(data.streetDetail)
            }
            checkEnableButton()
            isLoadingSubj.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingSubj.accept(false)
        }.disposed(by: disposeBag)
    }
}


extension DiamondPhysicalShippingViewModel {
    func validateName(_ name: String?) {
        if (name ?? "").trim().isEmpty {
            nameErrorTextSubj.accept("Tên người nhận không được bỏ trống")
        } else {
            nameErrorTextSubj.accept(nil)
        }
        checkEnableButton()
    }

    func validatePhone(_ phone: String?) {
        let errorText = UtilHelper.validatePhone(phone)
        phoneErrorTextSubj.accept(errorText)
        checkEnableButton()
    }

    func checkEnableButton() {
        if !(output.nameInput.value ?? "").isEmpty &&
            (output.nameErrorText.value ?? "").isEmpty &&
            !(output.phoneInput.value ?? "").isEmpty &&
            (output.phoneErrorText.value ?? "").isEmpty &&
            !(output.selectedCity.value?.name ?? "").isEmpty &&
            !(output.selectedDistrict.value?.name ?? "").isEmpty &&
            !(output.selectedWard.value?.name ?? "").isEmpty &&
            !(output.detailAddressInput.value ?? "").trim().isEmpty {
            isEnableButtonSubj.accept(true)
        } else {
            isEnableButtonSubj.accept(false)
        }
    }

    func onSelectedCity(location: LocationModel?) {
        selectedCitySubj.accept(location)
        selectedDistrictSubj.accept(nil)
        selectedWardSubj.accept(nil)
        districtsSubj.accept([])
        wardsSubj.accept([])
        getListLocation(type: .district, fatherId: location?.code)
        checkEnableButton()
    }

    func onSelectedDistrict(location: LocationModel?) {
        selectedDistrictSubj.accept(location)
        selectedWardSubj.accept(nil)
        wardsSubj.accept([])
        getListLocation(type: .ward, fatherId: location?.code)
        checkEnableButton()
    }

    func onSelectedWard(location: LocationModel?) {
        selectedWardSubj.accept(location)
        checkEnableButton()
    }

    func onEditDetailAddress() {
        checkEnableButton()
    }

    func getReceiverInfo() -> ReceiverInfoModel {
        return ReceiverInfoModel(
            name: output.nameInput.value,
            phoneNumber: output.phoneInput.value,
            city: output.selectedCity.value,
            district: output.selectedDistrict.value,
            ward: output.selectedWard.value,
            detailAddress: output.detailAddressInput.value,
            note: output.noteInput.value
        )
    }
}

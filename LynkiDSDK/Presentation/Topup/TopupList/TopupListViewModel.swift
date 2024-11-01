//
//  TopupListViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 09/08/2024.
//

import Foundation
import RxRelay
import RxSwift

class TopupListViewModel {
    private let disposeBag = DisposeBag()
    private let topupRepository: TopupRepository

    var isLoadingBrand = BehaviorRelay<Bool>(value: false)
    var isLoadingGift = BehaviorRelay<Bool>(value: false)
    var selectedBrand = BehaviorRelay<TopupBrandItem?>(value: nil)
    var selectedGift = BehaviorRelay<GiftInfoItem?>(value: nil)
    var hotGiftList = BehaviorRelay<[GiftInfoItem]>(value: [])
    var giftGroupList = BehaviorRelay<[TopupGroupModel]>(value: [])
    var brandList = BehaviorRelay<[TopupBrandModel]>(value: [])
    var phoneInput = BehaviorRelay<String?>(value: nil)
    var phoneErrorText = BehaviorRelay<String?>(value: nil)
    var isEnableButton = BehaviorRelay<Bool>(value: false)


    let topupPhoneType: TopupPhoneType?
    let topupDataType: TopupDataType?
    var topupType: TopupType = .topupPhone

    init(topupRepository: TopupRepository, topupPhoneType: TopupPhoneType? = nil, topupDataType: TopupDataType? = nil) {
        self.topupRepository = topupRepository
        self.topupPhoneType = topupPhoneType
        self.topupDataType = topupDataType
        if let _ = topupPhoneType {
            topupType = .topupPhone
        }
        if let _ = topupDataType {
            topupType = .topupData
        }
    }

    func setSelectedBrand(brand: TopupBrandItem) {
        selectedBrand.accept(brand)
        getTopupGiftList()
        getHotGiftList()
    }

    func setSelectedGift(gift: GiftInfoItem) {
        selectedGift.accept(gift)
        checkEnableButton()
    }

    func setInputPhone(_ phone: String?) {
        phoneInput.accept(phone)
        validatePhone(phone)
    }

}

extension TopupListViewModel {

    func getCateCode() -> String {
        if (topupType == .topupPhone) {
            return Constant.topupPhoneCateCode
        } else {
            return Constant.topupDataCateCode
        }
    }

    func viewDidLoad() {
        getTopupBrandList()
    }

    func getTopupGiftList(loadingState: LoadingState = .loading) {
        isLoadingGift.accept(true)
        topupRepository.getTopupGiftList(request: TopupGiftListRequest(
            brandIdFilter: selectedBrand.value?.brandId ?? -1,
            cateCode: getCateCode())
        )
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.result {
                let gifts = data.items ?? []
                var displayGifts = [GiftInfoItem]()
//                if (topupType == .topupPhone) {
//                    /// Chỉ lấy thẻ topup có [thirdPartyGiftCode] == null
//                    displayGifts = gifts.filter { $0.giftInfor?.thirdPartyGiftCode == nil }
//                    if !displayGifts.isEmpty {
//                        giftGroupList.accept([TopupGroupModel(title: "Mệnh giá", gifts: displayGifts)])
//                    } else {
//                        giftGroupList.accept([]);
//                    }
//                } else {
//                    /// Chỉ lấy thẻ cào có [thirdPartyGiftCode] != null
//                    displayGifts = gifts.filter { $0.giftInfor?.thirdPartyGiftCode != nil }
//                    /// group thẻ data có cùng giá trị [description]
//                    if !displayGifts.isEmpty {
//                        let dict = Dictionary(grouping: displayGifts, by: { $0.giftInfor?.description?.split(separator: ":").first })
//                        var groups = [TopupGroupModel]()
//                        for key in dict.keys {
//                            let listGift = (dict[key] ?? []) as [GiftInfoItem]
//                            groups.append(contentsOf: [TopupGroupModel(title: String(key ?? ""), gifts: listGift)])
//                        }
//                        giftGroupList.accept(groups)
//                    } else {
//                        giftGroupList.accept([]);
//                    }
//                }
                if (topupPhoneType == .buyCard || topupDataType == .buyCard) {
                    // Nếu mua mã thẻ
                    // Chỉ lấy thẻ topup có [thirdPartyGiftCode] != null
                    displayGifts = gifts.filter { $0.giftInfor?.thirdPartyGiftCode != nil }
                } else {
                    // Nếu nạp thẻ
                    // Chỉ lấy thẻ có [thirdPartyGiftCode] == null
                    displayGifts = gifts.filter { $0.giftInfor?.thirdPartyGiftCode == nil }
                }
                // Group thẻ
                if (!displayGifts.isEmpty) {
                    // Thẻ điện thoại
                    if (topupType == .topupPhone) {
                        giftGroupList.accept([TopupGroupModel(title: "Mệnh giá", gifts: displayGifts)])
                    } else {
                        //Thẻ data
                        let dict = Dictionary(grouping: displayGifts, by: { $0.giftInfor?.description?.split(separator: ":").first })
                        var groups = [TopupGroupModel]()
                        for key in dict.keys {
                            let listGift = (dict[key] ?? []) as [GiftInfoItem]
                            groups.append(contentsOf: [TopupGroupModel(title: String(key ?? ""), gifts: listGift)])
                        }
//                        var groups = [TopupGroupModel]()
//                        var dict = [String: [GiftInfoItem]]()
//                        for gift in displayGifts {
//                            let title: String = String(gift.giftInfor?.description?.split(separator: ":").first ?? "")
//                            if dict[title] == nil {
//                                dict[title] = []
//                            }
//                            dict[title]?.append(gift)
//                        }
//                        for key in dict.keys {
//                            let listGift = (dict[key] ?? []) as [GiftInfoItem]
//                            groups.append(contentsOf: [TopupGroupModel(title: String(key), gifts: listGift)])
//
//                        }
                        giftGroupList.accept(groups)
                    }
                } else {
                    giftGroupList.accept([]);
                }
                if let defaultGift = displayGifts.first {
                    setSelectedGift(gift: defaultGift)
                }
            }
            isLoadingGift.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGift.accept(false)
        }.disposed(by: disposeBag)
    }

    // Điện thoại - trả trước => giá trị type bằng 5.
    // Điện thoại - đổi mã thẻ => giá trị type bằng 6.
    // Điện thoại - trả sau. => giá trị type bằng 7.
    // Data 3G/4G - nạp data. => giá trị type bằng 8.
    // Data 3G/4G - Đổi mã thẻ. => giá trị type bằng 9.

    func getGroupType() -> Int {
        if topupType == .topupPhone, let topupPhoneType = topupPhoneType {
            switch topupPhoneType {
            case .prePaid:
                return 5
            case .buyCard:
                return 6
            case .postPaid:
                return 7
            }
        }
        if topupType == .topupData, let topupDataType = topupDataType {
            switch topupDataType {
            case .topup:
                return 8
            case .buyCard:
                return 9
            }
        }
        return -1
    }

    func getHotGiftList(loadingState: LoadingState = .loading) {
        isLoadingGift.accept(true)
        topupRepository.getTopupGiftGroup(request: TopupGiftGroupRequest(brandIdFilter: selectedBrand.value?.brandId ?? -1,
            groupType: getGroupType()
            )
        )
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.result {
                hotGiftList.accept(data.items ?? [])
            }
            isLoadingGift.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingGift.accept(false)
        }.disposed(by: disposeBag)
    }

    func getTopupBrandList(loadingState: LoadingState = .loading) {
        isLoadingBrand.accept(true)
        topupRepository.getTopupBrandList()
            .subscribe { [weak self] res in
            guard let self = self else { return }
            if let data = res.result {
                let dataBrands = data.filter { $0.brandMapping?.thirdPartyBrandId?.lowercased().contains("data") ?? false }
                let phoneBrands = data.filter { !($0.brandMapping?.thirdPartyBrandId?.lowercased().contains("data") ?? false) }
                let displayBrands = topupType == .topupPhone ? phoneBrands : dataBrands
                brandList.accept(displayBrands)
                /// lấy tên nhà cung cấp dựa theo đầu số điện thoại
                /// hoặc tên brandname
                let topupBrandType = UtilHelper.getTopupBrandType(phoneNumber: phoneInput.value ?? "")
                let selectedBrand = displayBrands.first(where: { UtilHelper.getTopupBrandType(brandName: $0.brandMapping?.brandName ?? "") == topupBrandType })
                if let brandInfo = selectedBrand?.brandMapping {
                    setSelectedBrand(brand: brandInfo)
                }
            }
            isLoadingBrand.accept(false)
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            isLoadingBrand.accept(false)
        }.disposed(by: disposeBag)
    }
}


extension TopupListViewModel {
    func validatePhone(_ phone: String?) {
        let errorText = getErrorMessage(phone)
        phoneErrorText.accept(errorText)
        checkEnableButton()
    }

    func getErrorMessage(_ phone: String?) -> String? {
        if (phone ?? "").trim().isEmpty {
            return "Thông tin không được bỏ trống"
        } else if (!UtilHelper.isValidPhoneNumber(phone ?? "")) {
            return "Thông tin chưa đúng định dạng"
        } else {
            return nil
        }
    }


    func getPhoneFormatter(_ phone: String?) -> String {
        let pureNumber = phone?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) ?? ""
        if (UtilHelper.isValidPhoneNumber(pureNumber)) {
            // lấy 9 số cuối trong dãy
            let suffix = pureNumber.suffix(9)
            return "0\(suffix)"
        } else {
            return pureNumber
        }
    }

    func checkEnableButton() {
        if (!(phoneInput.value ?? "").isEmpty
                && (phoneErrorText.value ?? "").isEmpty
                && selectedGift.value != nil) {
            isEnableButton.accept(true)
        } else {
            isEnableButton.accept(false)
        }
    }

    func getPhoneTitle(_ phoneInput: String?) -> String {
        let userPhone = getPhoneFormatter(AppConfig.shared.phoneNumber)
        if (userPhone == phoneInput) {
            return "Số của tôi"
        } else {
            return "Số điện thoại"
        }
    }

    func getEarnMoreCoin() -> Double {
        let giftInfor = selectedGift.value?.giftInfor
        let requiredCoin = giftInfor?.requiredCoin ?? 0
        let userPoint = AppUserDefaults.userPoint
        return requiredCoin - userPoint
    }

    func getEmptyTitle() -> String {
        let topupType = topupType == .topupPhone && topupPhoneType == .prePaid ? "trả trước" : "thẻ nạp";
        let brandName = selectedBrand.value?.brandName ?? "";
        let suffixContent = !brandName.isEmpty ? "từ nhà mạng \(brandName)" : "";
        return "Chưa có dữ liệu \(topupType) \(suffixContent)";
    }
}

struct TopupGroupModel {
    var title: String
    var gifts: [GiftInfoItem]
    init(title: String, gifts: [GiftInfoItem]) {
        self.title = title
        self.gifts = gifts
    }
}

//
//  AllGiftsRequestModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/02/2024.
//

import Foundation

struct AllGiftsRequestModel {
    var category: GiftCategory?
    var parentCateCode: String?
    var limit: Int
    var offset: Int
    var filterModel: GiftFilterModel?
    var brandId: String?
    var giftType: String?
    var sorting: GiftSorting?
    var tokenBalance: Int
    var searchText: String?

    init(category: GiftCategory? = nil,
        parentCateCode: String? = nil,
        limit: Int = 10,
        offset: Int = 0,
        filterModel: GiftFilterModel? = nil,
        brandId: String? = nil,
        giftType: String? = nil,
        sorting: GiftSorting? = nil,
        tokenBalance: Int = 0,
        searchText: String? = nil
    ) {
        self.category = category
        self.parentCateCode = parentCateCode
        self.limit = limit
        self.offset = offset
        self.filterModel = filterModel
        self.brandId = brandId
        self.giftType = giftType
        self.sorting = sorting
        self.tokenBalance = tokenBalance
        self.searchText = searchText
    }

    func getParams() -> [String: Any] {
        var params = [
            "MemberCode": AppConfig.shared.memberCode,
            "MaxItem": 5,
            "MaxResultCount": self.limit,
            "SkipCount": self.offset,
        ] as [String: Any]
        var fullGiftCategoryCodeFilter = ""

        if let brandId = self.brandId {
            params["BrandIdFilter"] = brandId
        }
        if let giftType = self.giftType {
            params["GiftTypeFilter"] = giftType
        }
        if let sorting = self.sorting {
            params["Sorting"] = sorting.value.id
        }
        if let category = category {
            fullGiftCategoryCodeFilter = category.code ?? ""
            params["CategoryTypeCode"] = category.categoryTypeCode
        }
        if let searchText = searchText {
            params["Filter"] = searchText
        }
        if let filterModel = self.filterModel {
            // Loại quà
            if let giftType = filterModel.giftType {
                params["IsEGiftFilter"] = giftType.id == "eGift" ? "true" : "false"
            }
            // Khoảng giá
            if let isSuitablePrice = filterModel.isSuitablePrice, isSuitablePrice {
                params["MaxRequiredCoinFilter"] = AppUserDefaults.userPoint
            } else {
                if let fromCoin = filterModel.fromCoin {
                    params["FromCointFilter"] = fromCoin
                }
                if let toCoin = filterModel.toCoin {
                    params["ToCoinFilter"] = toCoin
                }
            }
            // Địa điểm
            if let locations = filterModel.locations {
                params["RegionCodeFilter"] = locations.map { $0.id }.joined(separator: ";")
            }

            // Danh mục
            if let cates = filterModel.selectedCates, !cates.isEmpty {
                fullGiftCategoryCodeFilter = cates.map { $0.id }.joined(separator: ";")
            }
        }
        params["FullGiftCategoryCodeFilter"] = fullGiftCategoryCodeFilter
        return params
    }
}

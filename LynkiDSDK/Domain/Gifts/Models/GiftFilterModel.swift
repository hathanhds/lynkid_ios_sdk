//
//  GiftFilterModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/02/2024.
//

import Foundation

struct GiftFilterModel {
    var giftType: OptionModel?
    var locations: [OptionModel]?
    var fromCoin: Double?
    var toCoin: Double?
    var isSuitablePrice: Bool?
    var searchText: String?
    var selectedRange: RangeCoin?
    var selectedCates: [OptionModel]?
    var sorting: GiftSorting?

    init(giftType: OptionModel? = nil,
        locations: [OptionModel]? = nil,
        fromCoin: Double? = nil,
        toCoin: Double? = nil,
        isSuitablePrice: Bool? = nil,
        selectedRange: RangeCoin? = nil,
        selectedCates: [OptionModel]? = nil,
        sorting: GiftSorting? = nil) {
        self.giftType = giftType
        self.locations = locations
        self.fromCoin = fromCoin
        self.toCoin = toCoin
        self.isSuitablePrice = isSuitablePrice
        self.selectedRange = selectedRange
        self.selectedCates = selectedCates
        self.sorting = sorting
    }

    func copyWith(giftType: OptionModel? = nil,
        locations: [OptionModel]?,
        fromCoin: Double? = nil,
        toCoin: Double? = nil,
        isSuitablePrice: Bool? = nil,
        searchText: String? = nil,
        selectedRange: RangeCoin? = nil,
        selectedCates: [OptionModel]? = nil,
        sorting: GiftSorting? = nil
    ) -> GiftFilterModel {
        return GiftFilterModel(
            giftType: self.giftType ?? giftType,
            locations: self.locations ?? locations,
            fromCoin: self.fromCoin ?? fromCoin,
            toCoin: self.toCoin ?? toCoin,
            isSuitablePrice: self.isSuitablePrice ?? isSuitablePrice,
            selectedRange: self.selectedRange ?? selectedRange,
            selectedCates: self.selectedCates ?? selectedCates,
            sorting: self.sorting ?? sorting
        )
    }

    static var locations: [OptionModel] {
        return [
            OptionModel(id: "HN", title: "Hà Nội"),
            OptionModel(id: "HCM", title: "Hồ Chí Minh")
        ]
    }

    static var giftTypes: [OptionModel] {
        return [
            OptionModel(id: "eGift", title: "Voucher"),
            OptionModel(id: "physical", title: "Quà hiện vật")
        ]
    }
}

struct RangeCoin: Equatable {
    var id: String
    var fromCoin: Double
    var toCoin: Double
    var displayText: String

    init(id: String, fromCoin: Double, toCoin: Double, displayText: String) {
        self.id = id
        self.fromCoin = fromCoin
        self.toCoin = toCoin
        self.displayText = displayText
    }

    static func == (lhs: RangeCoin, rhs: RangeCoin) -> Bool {
        return lhs.id == rhs.id
    }

    static var defaultRangeCoinList: [RangeCoin] {
        return [
            RangeCoin(
                id: "1",
                fromCoin: 0,
                toCoin: 100000,
                displayText: "0 - 100k"
            ),
            RangeCoin(
                id: "2",
                fromCoin: 100000,
                toCoin: 200000,
                displayText: "100k - 200k"
            ),
            RangeCoin(
                id: "3",
                fromCoin: 200000,
                toCoin: 300000,
                displayText: "200k - 300k"
            ),
            RangeCoin(
                id: "4",
                fromCoin: 300000,
                toCoin: 500000,
                displayText: "300k - 500k"
            )
        ];
    }

    static var vpbankDiamondRangeCoinList: [RangeCoin] {
        return [
            RangeCoin(
                id: "1",
                fromCoin: 0,
                toCoin: 2000000,
                displayText: " < 2 triệu"
            ),
            RangeCoin(
                id: "2",
                fromCoin: 2000000,
                toCoin: 5000000,
                displayText: "2 - 5 triệu"
            ),
            RangeCoin(
                id: "3",
                fromCoin: 5000000,
                toCoin: 7000000,
                displayText: "5 - 7 triệu"
            )
        ]
    }
}

struct OptionModel: Equatable {
    var id: String
    var title: String

    init(id: String, title: String) {
        self.id = id
        self.title = title
    }

    static func == (lhs: OptionModel, rhs: OptionModel) -> Bool {
        return lhs.id == rhs.id
    }
}



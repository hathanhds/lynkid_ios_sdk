//
//  GiftsEnum.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 20/02/2024.
//

import Foundation

enum GiftType {
    case egift
    case physicalGift
    case none

    var title: String {
        switch self {
        case .egift: return "Voucher"
        case .physicalGift: return "Quà hiện vật"
        default: return ""
        }
    }
}

enum GiftSorting {
    case popular // phổ biến
    case lastest // mới nhất
    case totalWish // yêu thích nhất
    case requiredCoinAsc // giá quà tăng dần theo requiredCoin
    case requiredCoinDesc // giá quà giảm dần requiredCoin
    case priceLasted // giá tăng dần theo requiredCoin, nếu là quà flash sale sort theo salePrice
    case displayOrder

    var value: (id: String, title: String?) {
        switch self {
        case .popular:
            return (id: "totalRedeem", title: "Phổ biến nhất")
        case .lastest:
            return (id: "giftCreatedTime", title: "Mới nhất")
        case .totalWish:
            return (id: "TotalWish", title: nil)
        case .requiredCoinAsc:
            return (id: "priceLasted", title: "Giá giảm dần")
        case .requiredCoinDesc:
            return (id: "priceLasted DESC", title: "Giá giảm dần")
        case .priceLasted:
            return (id: "priceLasted", title: "Giá tăng dần")
        case .displayOrder:
            return (id: "displayOrder", title: "Giá tăng dần")
        }
    }
}


enum SearchState {
    case initial, searchResult, emptyResult
}

enum FlashSaleStatus: String {
    case upcoming_flash_sale = "Diễn ra sau"
    case in_flash_sale = "Kết thúc sau"
    case none = ""
}


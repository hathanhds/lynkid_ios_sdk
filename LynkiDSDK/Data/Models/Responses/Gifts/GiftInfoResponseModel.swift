//
//  GiftResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 23/01/2024.
//

import Foundation

class GiftDetailResponseModel: Codable {
    var result: GiftInfoItem?
}

struct GiftInfoItem: Codable {
    var giftTransaction: GiftTransaction?
    var eGift: EGift?
    var vendorInfo: VendorInfo?
    var imageLinks: [ImageLinkModel]?
    var imageLink: [ImageLinkModel]?
    var giftInfor: GiftInfor?
    var relatedGiftInfor: [GiftInfor]?
    var remainingQuantityOfTheGift: Int?
    var brandInfo: BrandInfo?
    var flashSaleProgramInfor: FlashSaleProgramInfor?
    var giftDiscountInfor: GiftDiscountInfor?
    var memberNameFrom: String?
    var memberImageLinkFrom: String?
    var isMaster: Bool?
    var isAvailableToRedeemAgain: Bool?
    var feeInfor: String?
    var giftCategoryTypeCode: String?
    var balanceAbleToCashout: Int?
    var giftUsageAddress: [GiftUsageLocationItem]?
    var thirdPartyCategoryName: String?

    var topupType: TopupType? {
        if (thirdPartyCategoryName == TopupType.topupPhone.rawValue) {
            return .topupPhone
        } else if (thirdPartyCategoryName == TopupType.topupData.rawValue) {
            return .topupData
        }
        return nil
    }
    
    init(giftTransaction: GiftTransaction? = nil, eGift: EGift? = nil, vendorInfo: VendorInfo? = nil, imageLinks: [ImageLinkModel]? = nil, imageLink: [ImageLinkModel]? = nil, giftInfor: GiftInfor? = nil, relatedGiftInfor: [GiftInfor]? = nil, remainingQuantityOfTheGift: Int? = nil, brandInfo: BrandInfo? = nil, flashSaleProgramInfor: FlashSaleProgramInfor? = nil, giftDiscountInfor: GiftDiscountInfor? = nil, memberNameFrom: String? = nil, memberImageLinkFrom: String? = nil, isMaster: Bool? = nil, isAvailableToRedeemAgain: Bool? = nil, feeInfor: String? = nil, giftCategoryTypeCode: String? = nil, balanceAbleToCashout: Int? = nil, giftUsageAddress: [GiftUsageLocationItem]? = nil, thirdPartyCategoryName: String? = nil) {
        self.giftTransaction = giftTransaction
        self.eGift = eGift
        self.vendorInfo = vendorInfo
        self.imageLinks = imageLinks
        self.imageLink = imageLink
        self.giftInfor = giftInfor
        self.relatedGiftInfor = relatedGiftInfor
        self.remainingQuantityOfTheGift = remainingQuantityOfTheGift
        self.brandInfo = brandInfo
        self.flashSaleProgramInfor = flashSaleProgramInfor
        self.giftDiscountInfor = giftDiscountInfor
        self.memberNameFrom = memberNameFrom
        self.memberImageLinkFrom = memberImageLinkFrom
        self.isMaster = isMaster
        self.isAvailableToRedeemAgain = isAvailableToRedeemAgain
        self.feeInfor = feeInfor
        self.giftCategoryTypeCode = giftCategoryTypeCode
        self.balanceAbleToCashout = balanceAbleToCashout
        self.giftUsageAddress = giftUsageAddress
        self.thirdPartyCategoryName = thirdPartyCategoryName
    }
}

struct GiftTransaction: Codable {
    var code: String?
    var buyerCode: String?
    var ownerCode: String?
    var transferTime: String?
    var memberName: String?
    var introduce: String?
    var tag: String?
    var phone: String?
    var address: String?
    var giftCode: String?
    var giftName: String?
    var name: String?
    var quantity: Int?
    var coin: Int?
    var date: String?
    var status: String?
    var whyHaveIt: String?
    var memberId: Int?
    var giftId: Int?
    var reason: String?
    var totalCoin: Double?
    var description: String?
    var lastModificationTime: String?
    var linkAvatar: String?
    var transactionCode: String?
    var qrCode: String?
    var codeDisplay: String?
    var id: Int?
    var linkShippingInfo: String?
    var serialNo: String?
    var recipientPhone: String?
    var contactHotline: String?
    var contactEmail: String?
    var condition: String?
    var giftDescription: String?
    var eGiftUsedAt: String?
    var rejectReason: String?
    var isExperienceGift: Bool?
    
    var whyHaveItType: WhyHaveRewardType? {
        return WhyHaveRewardType.allValues.first(where: {$0.rawValue == whyHaveIt})
    }
}

struct EGift: Codable {
    var type: String?
    var code: String?
    var description: String?
    var status: String?
    var usedStatus: String?
    var expiredDate: String?
    var giftCode: String?
    var giftId: Int?
    var lastModificationTime: String?
    var creationTime: String?
    var usageCheck: Bool?
}

struct GiftInfor: Codable {
    var code: String?
    var name: String?
    var description: String?
    var introduce: String?
    var fullGiftCategoryCode: String?
    var producer: String?
    var vendor: String?
    var effectiveFrom: String?
    var effectiveTo: String?
    var requiredCoin: Double?
    var status: String?
    var totalQuantity: Int?
    var usedQuantity: Int?
    var remainingQuantity: Int?
    var fullPrice: Double?
    var discountPrice: Double?
    var isEGift: Bool?
    var tag: String?
    var isInWishlist: Bool?
    var id: Int?
    var regionCode: String?
    var expireDuration: String?
    var totalWish: Int?
    var doubleroduce: String?
    var vendorHotline: String?
    var isTypeCashout: Bool?
    var isGiftDiamond: Bool?

    var vendorName: String?
    var vendorType: String?
    var vendorImage: String?
    var vendorDescription: String?

    var merchantId: Int?
    var merchantName: String?
    var merchantAvatar: String?
    var merchantDescription: String?

    var brandId: Int?
    var brandName: String?
    var brandLinkLogo: String?
    var brandDescription: String?
    var brandAddress: String?
    var isBrandFavourite: Bool?

    var commisPercentCategory: Int?
    var thirdPartyCategoryName: String?
    var thirdPartyGiftCode: String?
    var giftGroup: [GiftGroup]?;

    var condition: String?
    var officeAddress: String?
    var contactEmail: String?
    var contactHotline: String?
    var totalRedeemedOfUser: Int?
    var maxAllowedRedemptionOfUser: Int?
    var maxQuantityPerRedemptionOfUser: Int?
    var imageLink: [ImageLink]?
    
    
}

struct BrandInfo: Codable {
    var brandId: Int?
    var brandName: String?
    var brandImage: String?
    var isBrandFavourite: Bool?
}

struct FlashSaleProgramInfor: Codable {
    var id: Int?
    var code: String?
    var name: String?
    var startTime: String?
    var endTime: String?
    var creationTime: String?
    var creatorUserId: Int?
    var creatorUserName: String?
    var status: String?
    var maxGiftPerCustomer: Int? // số lượng đổi qùa tối đa của chương trình
    var displayTime: String?
    var url: String?
    var image: String?
    var giftInFlashSaleProgramForViews: [FlashSaleGiftItem]?
}

struct FlashSaleGiftItem: Codable {
    var giftId: Int?
    var giftCode: String?
    var imageLink: String?
    var giftName: String?
    var remainingQuantity: Double? // quà còn lại trong kho
    var amount: Double? // tổng quà trong chương trình flash sale
    var remainingQuantityFlashSale: Int? // quà còn lại trong chương trình flash sale
    var originalPrice: Double?
    var salePrice: Double?
    var reductionRateDisplay: Int?
    var usedQuantityFlashSale: Int? // số lượng quà flash sale đã đổi
    var warningOutOfStock: Bool? // cảnh báo sắp hết hàng
    var fullGiftCategoryCode: String?
    var totalWish: Int?
}

struct GiftDiscountInfor: Codable {
    var salePrice: Double?
    var remainingQuantityFlashSale: Int?
    var reductionRateDisplay: Double?
    var warningOutOfStock: Bool?
    var status: String?
    var redeemGiftQuantity: Int? // số lượng đã đổi của quà trong chương trình
    var redeemFlashSaleQuantity: Int? // số lượng đã đổi quà của cả chương trình
    var maxAmountRedeem: Int?
}

struct VendorInfo: Codable {
    var image: String?
    var hotLine: String?
    var id: Int?
    var type: String?
}


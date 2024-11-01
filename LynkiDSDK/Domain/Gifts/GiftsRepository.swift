//
//  GiftsRepository.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/01/2024.
//

import RxSwift

protocol GiftsRepository {
    func getListGiftCate() -> Single<BaseResponseModel2<GiftCateResultModel>>
    func getListGiftDiamondCate(request: ListCateDiamondRequestModel) -> Single<BaseResponseModel<GiftDiamondCateResultModel>>
    func getListGiftGroupForHomepage(maxItem: Int?) -> Single<GiftGroupsResponseModel>
    func getALlGifts(request: AllGiftsRequestModel) -> Single<GiftListResponseModel>
    func getALlDiamondGifts(request: AllGiftsRequestModel) -> Single<DiamondGiftListResponseModel>
    func getAllGiftGroups() -> Single<AllGiftsByGroupResponseModel>
    func getListGiftByGroup(groupCode: String, limit: Int, offset: Int) -> Single<GiftListResponseModel>
    func getGiftUsageLocation(request: GiftUsageLocationRequest) -> Single<BaseResponseModel<GiftUsageLocationResponseModel>>
    func getGiftDetail(giftId: String) -> Single<BaseResponseModel2<GiftInfoItem>>
    func createTransaction(request: CreateTransactionRequestModel) -> Single<BaseResponseModel2<CreateTransactionResponseModel>>
    func confirmOtpCreateTransaction(sessionId: String, otpCode: String) -> Single<BaseResponseModel2<CreateTransactionResponseModel>>
    func resendOtp(sessionId: String) -> Single<BaseResponseModel<Int>>
}

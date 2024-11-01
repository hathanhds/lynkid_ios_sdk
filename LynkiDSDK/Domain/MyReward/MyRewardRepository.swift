//
//  MyRewardRepository.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/05/2024.
//

import RxSwift

protocol MyrewardRepository {
    func getListReward(request: MyRewardRequestModel) -> Single<BaseResponseModel<GiftListResultModel>>
    func getMyRewardDetail(giftTransactionCode: String) -> Single<BaseResponseModel<GiftListResultModel>>
    func updateGiftStatus(transactionCode: String, topupChannel: TopupChannel?) -> Single<BaseResponseModel<String?>>
}

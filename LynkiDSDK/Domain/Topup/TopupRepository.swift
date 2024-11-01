//
//  TopupRepository.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/08/2024.
//

import RxSwift

protocol TopupRepository {
    func getTopupGiftList(request: TopupGiftListRequest) -> Single<BaseResponseModel<GiftListResultModel>>
    func getTopupGiftGroup(request: TopupGiftGroupRequest) -> Single<BaseResponseModel<GiftListResultModel>>
    func getTopupBrandList() -> Single<BaseResponseModel<[TopupBrandModel]>>
    func getTopupTransactionList(request: TopupTransactionListRequest) -> Single<TopupTransactionListResponseModel>
}

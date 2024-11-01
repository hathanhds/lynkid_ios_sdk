//
//  MyrewardRepositoryImp.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/05/2024.
//

import RxSwift

class MyrewardRepositoryImpl: MyrewardRepository {
    private let disposeBag = DisposeBag()

    func getListReward(request: MyRewardRequestModel) -> Single<BaseResponseModel<GiftListResultModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListReward(request: request))
                .map({ res -> BaseResponseModel<GiftListResultModel> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel<GiftListResultModel>.self)
                    return model
                } catch {
                    throw APIError.somethingWentWrong
                }
            })
                .subscribe(onSuccess: { model in
                observer(.success(model))
            }, onFailure: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }.observe(on: MainScheduler())
    }

    func getMyRewardDetail(giftTransactionCode: String) -> Single<BaseResponseModel<GiftListResultModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getMyRewardDetail(giftTransactionCode: giftTransactionCode))
                .map({ res -> BaseResponseModel<GiftListResultModel> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel<GiftListResultModel>.self)
                    return model
                } catch {
                    throw APIError.somethingWentWrong
                }
            })
                .subscribe(onSuccess: { model in
                observer(.success(model))
            }, onFailure: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }.observe(on: MainScheduler())
    }

    func updateGiftStatus(transactionCode: String, topupChannel: TopupChannel?) -> Single<BaseResponseModel<String?>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .updateGiftStatus(transactionCode: transactionCode, topupChannel: topupChannel))
                .map({ res -> BaseResponseModel<String?> in
                let data = res.data
                do {
                    // MARK: -NotificationCenter
                    /// Cập nhật danh sách quà đã mua, danh sách thẻ đã mua khi cập nhật trạng thái quà
                    NotificationCenter.dispatch(name: .updateMyRewardList)
                    if (topupChannel != nil) {
                        NotificationCenter.dispatch(name: .updateTopupTransactionList)
                    }
                    let model = try data.decoded(type: BaseResponseModel<String?>.self)
                    return model
                } catch {
                    throw APIError.somethingWentWrong
                }
            })
                .subscribe(onSuccess: { model in
                observer(.success(model))
            }, onFailure: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }.observe(on: MainScheduler())
    }

}

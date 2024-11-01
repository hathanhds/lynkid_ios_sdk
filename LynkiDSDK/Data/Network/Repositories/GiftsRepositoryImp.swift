//
//  GiftsRepositoryImp.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 30/01/2024.
//

import RxSwift

class GiftsRepositoryImpl: GiftsRepository {

    private let disposeBag = DisposeBag()

    func getListGiftCate() -> Single<BaseResponseModel2<GiftCateResultModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListGiftCate)
                .map({ res -> BaseResponseModel2<GiftCateResultModel> in
                let data = res.data
                if let model = try? data.decoded(type: BaseResponseModel2<GiftCateResultModel>.self) {
                    return model
                } else {
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

    func getListGiftGroupForHomepage(maxItem: Int?) -> RxSwift.Single<GiftGroupsResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListGiftGroupForHomePage(maxItem: maxItem))
                .map({ res -> GiftGroupsResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: GiftGroupsResponseModel.self) {
                    return model
                } else {
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

    func getALlGifts(request: AllGiftsRequestModel) -> Single<GiftListResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getAllGifts(request: request))
                .map({ res -> GiftListResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: GiftListResponseModel.self)
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

    func getAllGiftGroups() -> Single<AllGiftsByGroupResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getAllGiftGroups)
                .map({ res -> AllGiftsByGroupResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: AllGiftsByGroupResponseModel.self) {
                    return model
                } else {
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

    func getListGiftByGroup(groupCode: String, limit: Int, offset: Int) -> Single<GiftListResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListGiftsByGroup(groupCode: groupCode, limit: limit, offset: offset))
                .map({ res -> GiftListResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: GiftListResponseModel.self)
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

    func getGiftUsageLocation(request: GiftUsageLocationRequest) -> Single<BaseResponseModel<GiftUsageLocationResponseModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getGiftUsageLocation(request: request))
                .map({ res -> BaseResponseModel<GiftUsageLocationResponseModel> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel<GiftUsageLocationResponseModel>.self)
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


    func getListGiftDiamondCate(request: ListCateDiamondRequestModel) -> Single<BaseResponseModel<GiftDiamondCateResultModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListGiftCateDiamond(request: request))
                .map({ res -> BaseResponseModel<GiftDiamondCateResultModel> in
                let data = res.data
                if let model = try? data.decoded(type: BaseResponseModel<GiftDiamondCateResultModel>.self) {
                    return model
                } else {
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
        }
    }

    func getALlDiamondGifts(request: AllGiftsRequestModel) -> Single<DiamondGiftListResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getAllGifts(request: request))
                .map({ res -> DiamondGiftListResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: DiamondGiftListResponseModel.self)
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

    func getGiftDetail(giftId: String) -> Single<BaseResponseModel2<GiftInfoItem>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getGiftDetail(giftId: giftId))
                .map({ res -> BaseResponseModel2<GiftInfoItem> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel2<GiftInfoItem>.self)
                    return model
                } catch {
                    throw APIError.somethingWentWrong
                }
//                let path = UtilHelper.bundle.path(forResource: "gift_detail", ofType: "json") ?? ""
//                if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
// {
//                    do {
//                        let model = try data.decoded(type: BaseResponseModel2<GiftInfoItem>.self)
//                        return model
//                    } catch {
//                        throw APIError.somethingWentWrong
//                    }
//
//                } else {
//                    throw APIError.somethingWentWrong
//                }
            })
                .subscribe(onSuccess: { model in
                observer(.success(model))
            }, onFailure: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }

    func createTransaction(request: CreateTransactionRequestModel) -> Single<BaseResponseModel2<CreateTransactionResponseModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .createTransaction(request: request))
                .map({ res -> BaseResponseModel2<CreateTransactionResponseModel> in
                let data = res.data
                do {
                    /// Đổi quà: Cập nhật user coin, danh sách quà đã mua, danh sách thẻ nạp, lịch sử giao dịch
                    NotificationCenter.dispatch(name: .updateUerCoin)
                    NotificationCenter.dispatch(name: .updateMyRewardList)
                    NotificationCenter.dispatch(name: .updateTransactionHistory)
                    if (request.topupInfo != nil) {
                        NotificationCenter.dispatch(name: .updateTopupTransactionList)
                    }
                    let model = try data.decoded(type: BaseResponseModel2<CreateTransactionResponseModel>.self)
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


    func confirmOtpCreateTransaction(sessionId: String, otpCode: String) -> Single<BaseResponseModel2<CreateTransactionResponseModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .confirmOtpCreateTransaction(sessionId: sessionId, otpCode: otpCode))
                .map({ res -> BaseResponseModel2<CreateTransactionResponseModel> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel2<CreateTransactionResponseModel>.self)
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

    func resendOtp(sessionId: String) -> Single<BaseResponseModel<Int>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .resendOtp(sessionId: sessionId))
                .map({ res -> BaseResponseModel<Int> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel<Int>.self)
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

//
//  TopupRepositoryImp.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/08/2024.
//

import RxSwift

class TopupRepositoryImp: TopupRepository {
    private let disposeBag = DisposeBag()

    func getTopupGiftList(request: TopupGiftListRequest) -> Single<BaseResponseModel<GiftListResultModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getTopupGiftList(request: request))
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
        }
    }

    func getTopupGiftGroup(request: TopupGiftGroupRequest) -> Single<BaseResponseModel<GiftListResultModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getTopupGiftGroup(request: request))
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
        }
    }

    func getTopupBrandList() -> Single<BaseResponseModel<[TopupBrandModel]>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getTopupBrandList)
                .map({ res -> BaseResponseModel<[TopupBrandModel]> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel<[TopupBrandModel]>.self)
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
        }
    }

    func getTopupTransactionList(request: TopupTransactionListRequest) -> Single<TopupTransactionListResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getTopupTransactionList(request: request))
                .map({ res -> TopupTransactionListResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: TopupTransactionListResponseModel.self)
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

//            let path = UtilHelper.bundle.path(forResource: "topup_transaction", ofType: "json") ?? ""
//            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//            {
//                do {
//                    let model = try data.decoded(type: TopupTransactionListResponseModel.self)
//                    observer(.success(model))
//                } catch {
//                    observer(.failure(APIError.somethingWentWrong))
//                }
//            } else {
//                observer(.failure(APIError.somethingWentWrong))
//            }

            return Disposables.create()
        }
    }

}

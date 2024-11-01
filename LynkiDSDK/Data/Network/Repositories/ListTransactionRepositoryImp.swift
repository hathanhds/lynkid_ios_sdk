//
//  ListTransactionRepositoryImp.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 03/06/2024.
//

import RxSwift

class ListTransactionRepositoryImp: TransactionRepository{
    
    private let disposeBag = DisposeBag()
    
    func getListTransaction(request: TransactionHistoryRequestModel) -> RxSwift.Single<TransactionListResultModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListTransaction(request: request))
                .map({ res -> TransactionListResultModel in
                let data = res.data
                    
                if let model = try? data.decoded(type: TransactionListResultModel.self) {
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
    
    
    func getDetailTransaction(request: TransactionDetailRequestModel) -> RxSwift.Single<TransactionDetailResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getDetailTransaction(request: request))
                .map({ res -> TransactionDetailResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: TransactionDetailResponseModel.self) {
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
}

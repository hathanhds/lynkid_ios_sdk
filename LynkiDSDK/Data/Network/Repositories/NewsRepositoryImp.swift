//
//  NewsServiceImp.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 17/01/2024.
//

import RxSwift

class NewsRepositoryImpl: NewsRepository {
    private let disposeBag = DisposeBag()

    func getListNewsAndBanner() -> Single<BaseResponseModel2<[HomeNewsAndBannerResultModel]>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListNewsAndBanner)
                .map({ res -> BaseResponseModel2<[HomeNewsAndBannerResultModel]> in
                let data = res.data
                if let model = try? data.decoded(type: BaseResponseModel2<[HomeNewsAndBannerResultModel]>.self) {
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


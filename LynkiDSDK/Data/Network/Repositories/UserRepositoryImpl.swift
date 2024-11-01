//
//  UserRepositoryImpl.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 02/02/2024.
//

import RxSwift

class UserRepositoryImpl: UserRepository {
    
    private let disposeBag = DisposeBag()

    func getMemberView() -> Single<MemberViewResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getMemberView)
                .map({ res -> MemberViewResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: MemberViewResponseModel.self) {
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

    func getUserPoint() -> RxSwift.Single<BaseResponseModel2<UserPointResponseModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getUserPoint)
                .map({ res -> BaseResponseModel2<UserPointResponseModel> in
                let data = res.data
                if let model = try? data.decoded(type: BaseResponseModel2<UserPointResponseModel>.self) {
                    AppUserDefaults.userPoint = Double(model.data?.items?.tokenBalance ?? 0)
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

    func getLocation(request: LocationRequestModel) -> Single<BaseResponseModel<LocationResponseModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getLocation(request: request))
                .map({ res -> BaseResponseModel<LocationResponseModel> in
                let data = res.data
                if let model = try? data.decoded(type: BaseResponseModel<LocationResponseModel>.self) {
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
    
    func getMemberVpbankInfor() -> Single<VpbankMemberInforResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getMemberVpbankInfor)
                .map({ res -> VpbankMemberInforResponseModel in
                let data = res.data
                if let model = try? data.decoded(type: VpbankMemberInforResponseModel.self) {
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


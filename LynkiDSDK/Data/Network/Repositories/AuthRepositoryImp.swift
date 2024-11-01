//
//  AuthRepositoryImp.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/03/2024.
//

import Foundation
import RxSwift

class AuthRepositoryImp: AuthRepository {

    private let disposeBag = DisposeBag()

    func generatePartnerToken(phoneNumber: String, cif: String, name: String) -> Single<GenerateTokenPartnerResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .generatePartnerToken(phoneNumber: phoneNumber, cif: cif, name: name))
                .map({ res -> GenerateTokenPartnerResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: GenerateTokenPartnerResponseModel.self)
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

    func checkMemberAndConnection(phoneNumber: String, cif: String) -> Single<BaseResponseModel2<MemberConnectionDataModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .checkMemberAndConnection(phoneNumber: phoneNumber, cif: cif))
                .map({ res -> BaseResponseModel2<MemberConnectionDataModel> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel2<MemberConnectionDataModel>.self)
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

    func authenWithConnectedPhone(originalPhone: String, connectedPhone: String) -> Single<BaseResponseModel2<AuthConnectedPhoneDataModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .authenWithConnectedPhone(originalPhone: originalPhone, connectedPhone: connectedPhone))
                .map({ res -> BaseResponseModel2<AuthConnectedPhoneDataModel> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel2<AuthConnectedPhoneDataModel>.self)
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

    func createMember(phoneNumber: String, cif: String, name: String) -> Single<BaseResponseModel2<MemberConnectionDataModel>> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .createMember(phoneNumber: phoneNumber, cif: cif, name: name))
                .map({ res -> BaseResponseModel2<MemberConnectionDataModel> in
                let data = res.data
                do {
                    let model = try data.decoded(type: BaseResponseModel2<MemberConnectionDataModel>.self)
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

    func getTermsOrPolicy(type: TermsAndPolicyType) -> RxSwift.Single<NewsResponseModel> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: type == .terms ? .getTermsAndConditions : .getSecurityPolicy)
                .map({ res -> NewsResponseModel in
                let data = res.data
                do {
                    let model = try data.decoded(type: NewsResponseModel.self)
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

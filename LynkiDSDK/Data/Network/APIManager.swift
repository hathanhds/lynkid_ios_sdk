//
//  APIManager.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 16/02/2024.
//

import Foundation
import Moya
import RxSwift
import Alamofire

class APIManager {

    private static let shared = APIManager()

    class DefaultAlamofireSession: Alamofire.Session {
        static let shared: DefaultAlamofireSession = {
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            configuration.timeoutIntervalForRequest = 60 // in second
            configuration.timeoutIntervalForResource = 60 // in second
            configuration.requestCachePolicy = .useProtocolCachePolicy
            return DefaultAlamofireSession(configuration: configuration)
        }()
    }

    private let provider = MoyaProvider<APIService>(
        session: DefaultAlamofireSession.shared,
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]).rx

    private let disposeBag = DisposeBag()

    private init() { }

    private static func hanldeFailedRequest(observer: (Result<Response, Error>) -> Void, data: Data) {
        do {
            let model = try data.decoded(type: APIErrorResponseModel.self)
            observer(.failure(model))
        } catch {
            observer(.failure(APIError.somethingWentWrong))
        }
    }

    static func request(target: APIService, onQueue queue: DispatchQueue? = .global()) -> Single<Response> {

        guard NetworkManager.shared.isNetworkconnected else {
            return Single.create { observer -> Disposable in
                observer(.failure(APIError.noInternetConnection))
                return Disposables.create()
            }
        }

        switch target.tokenType {
        case .accessToken:
            return Single.create { observer -> Disposable in
                let refreshAccessTokenRequest = {
                    shared.refreshAccessToken(tokenType: target.tokenType)
                        .subscribe(onSuccess: { data in
                        AppConfig.shared.accessToken = data.accessToken ?? ""
                        AppConfig.shared.refreshToken = data.refreshToken ?? ""
                        shared.provider.request(target, callbackQueue: queue)
                            .subscribe { (event) in
                            observer(event)
                        }
                            .disposed(by: self.shared.disposeBag)
                    }, onFailure: { _ in
                            observer(.failure(APIError.somethingWentWrong))
//                            UtilHelper.showAccessTokenExpired()
                        })
                        .disposed(by: self.shared.disposeBag)
                }

                shared.provider.request(target, callbackQueue: queue)
                    .subscribe(
                    onSuccess: { res in
                        switch res.statusCode {
                        case 200...300:
                            observer(.success(res))
                        case 401:
                            refreshAccessTokenRequest()
                        default:
                            hanldeFailedRequest(observer: observer, data: res.data)
                        }

                    }, onFailure: { _ in
                        observer(.failure(APIError.somethingWentWrong))
//                        UtilHelper.showAccessTokenExpired()
                    })
                    .disposed(by: shared.disposeBag)
                return Disposables.create()
            }.observe(on: MainScheduler.instance)
        case .seedToken:
            return Single.create { observer -> Disposable in
                let refreshSeedTokenRequest = {
                    shared.refreshAccessToken(tokenType: target.tokenType)
                        .subscribe(onSuccess: { data in
                        AppConfig.shared.seedToken = data.accessToken ?? ""
                        AppConfig.shared.refreshSeedToken = data.refreshToken ?? ""
                        shared.provider.request(target, callbackQueue: queue)
                            .subscribe { (event) in
                            observer(event)
                        }
                            .disposed(by: self.shared.disposeBag)
                    }, onFailure: { _ in
                            observer(.failure(APIError.somethingWentWrong))
//                            UtilHelper.showAccessTokenExpired()
                        })
                        .disposed(by: self.shared.disposeBag)
                }

                shared.provider.request(target, callbackQueue: queue)
                    .subscribe(
                    onSuccess: { res in
                        switch res.statusCode {
                        case 200...300:
                            observer(.success(res))
                        case 401:
                            refreshSeedTokenRequest()
                        default:
                            hanldeFailedRequest(observer: observer, data: res.data)
                        }
                    }, onFailure: { _ in
                        observer(.failure(APIError.somethingWentWrong))
//                        UtilHelper.showAccessTokenExpired()
                    })
                    .disposed(by: shared.disposeBag)
                return Disposables.create()
            }.observe(on: MainScheduler.instance)
        case .none:
            return Single.create { observer -> Disposable in
                shared.provider.request(target, callbackQueue: queue)
                    .subscribe(
                    onSuccess: { res in
                        switch res.statusCode {
                        case 200...300:
                            observer(.success(res))
                        default:
                            if (target.path == APIConstant.sdk.refreshToken) {
                                observer(.failure(APIError.unauthorized))
                            } else {
                                hanldeFailedRequest(observer: observer, data: res.data)
                            }
                        }
                    }, onFailure: { _ in
                        observer(.failure(APIError.somethingWentWrong))
                    })
                    .disposed(by: shared.disposeBag)
                return Disposables.create()
            }.observe(on: MainScheduler.instance)
        }
    }
}


extension APIManager {
    private func refreshAccessToken(tokenType: APIService.TokenType) -> Single<RefreshTokenResponseModel> {
        let refreshToken = tokenType == .accessToken ? AppConfig.shared.refreshToken : AppConfig.shared.refreshSeedToken
        guard !refreshToken.isEmpty else {
            return Single.create { observer -> Disposable in
                observer(.failure(APIError.unauthorized))
                return Disposables.create()
            }
        }
        return APIManager.request(target: .refreshToken(refreshToken: refreshToken))
            .map({ res -> RefreshTokenResponseModel in

            do {
                let model = try res.data.decoded(type: RefreshTokenResponseModel.self)
                return model
            } catch {
                throw APIError.somethingWentWrong
            }
        })
    }
}


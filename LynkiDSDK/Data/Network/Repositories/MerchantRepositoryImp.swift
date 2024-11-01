//
//  MerchantRepositoryImp.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 04/06/2024.
//

import RxSwift
import Foundation

class MerchantRepositoryImp: MerchantRepository{
    private let disposeBag = DisposeBag()
    
    func getListMerchant(request: MerchantRequestModel) -> RxSwift.Single<Void> {
        return Single.create { observer -> Disposable in
            APIManager.request(target: .getListMerchant(request: request))
                .map({ res -> Void in
                let data = res.data
                    let defaults = UserDefaults.standard
                    defaults.set(data, forKey: Constant.kAllMerchant)
            })
                .subscribe(onSuccess: { _ in
                    observer(.success(()))
            }, onFailure: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }.observe(on: MainScheduler())
    }
    
    
}

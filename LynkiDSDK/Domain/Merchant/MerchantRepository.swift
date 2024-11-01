//
//  MerchantRepository.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 04/06/2024.
//

import RxSwift

protocol MerchantRepository {
    func getListMerchant(request: MerchantRequestModel) -> Single<Void>

}

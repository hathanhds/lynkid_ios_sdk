//
//  NewsServiceProtocol.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 17/01/2024.
//

import RxSwift

protocol NewsRepository {
    func getListNewsAndBanner() -> Single<BaseResponseModel2<[HomeNewsAndBannerResultModel]>>
}




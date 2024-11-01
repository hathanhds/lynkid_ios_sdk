//
//  HomeNewsAndBannerResponseModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 27/01/2024.
//

import Foundation

struct HomeNewsAndBannerResponseModel: Codable {
    var result: [HomeNewsAndBannerResultModel]?
}

struct HomeNewsAndBannerResultModel: Codable {
    var type: Int?
    var resultDto: NewsAndBannerResultModel?
}


struct NewsAndBannerResultModel: Codable {
    var totalCount: Int?
    var items: [NewsItem]?
}

//
//  APIResponse.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 17/01/2024.
//

import Foundation

struct BaseResponseModel<T: Codable>: Codable {
    var targetUrl: String?
    var success: Bool?
    var error: String?
    var unAuthorizedRequest: Bool?
    var result: T?
    var code: String?
    var message: String?
    var messageDetail: String?
}

struct BaseResponseModel2<T: Codable>: Codable {
    var data: T?
    var code: String?
    var message: String?
    var isSuccess: Bool?
}

struct APIErrorResponseModel: Codable, LocalizedError {
    var code: String?
    var message: String?
    var messageDetail: String?
}


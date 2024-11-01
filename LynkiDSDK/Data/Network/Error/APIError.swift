//
//  AppError.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 26/01/2024.
//

import Foundation

enum APIError: String, LocalizedError {
    case somethingWentWrong = "Có lỗi hệ thống. Vui lòng thử lại sau"
    case unauthorized = "Phiên đăng nhập đã hết hạn, để tiếp tục sử dụng mời bạn đăng nhập lại nhé."
    case noInternetConnection = "Vui lòng kiểm tra kết nối mạng"
    case notFound = "Không tìm thấy dữ liệu"
}

extension APIError {
    var errorDescription: String? {
        return self.rawValue
    }
}

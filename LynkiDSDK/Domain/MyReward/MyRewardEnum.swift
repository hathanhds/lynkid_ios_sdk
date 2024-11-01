//
//  MyRewardEnum.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 13/05/2024.
//

import Foundation

enum MyRewardType {
    case myOwnedReward
    case myUsedReward
}

// Danh sách tiến trình
// 1. Chờ xử ý ->  Đang giao hàng -> Đã giao hàng
// 2. Chờ xử lý -> Đã hủy
// 3. Chờ xử lý -> Đang giao hàng -> Vận chuyển trả hàng -> Đã hủy

enum PhysicalRewardStatus: String, CaseIterable {
    case pending // 1-1 (tiến trình 1 - trạng thái 1)
    case waiting // 1-1
    case delivering // 1-2
    case delivered // 1-3
    case returning // 3-3
    case returned // 3-4
    case cancelling // 3-4
    case canceled // 3-4
    case confirmFailed // 1-1
    case confirmed // 1-1
    case rejected // 2-2
    case approved // 1-1

    var progressInfo: ProgressInfo {
        switch self {
        case .pending,
             .waiting,
             .confirmFailed,
             .confirmed,
             .approved:
            return ProgressInfo(progressNumber: 1, progressIndex: 1); // 1-1
        case .delivering:
            return ProgressInfo(progressNumber: 1, progressIndex: 2); // 1-2
        case .delivered:
            return ProgressInfo(progressNumber: 1, progressIndex: 3); // 1-3
        case .rejected:
            return ProgressInfo(progressNumber: 2, progressIndex: 2); // 1-3
        case .returning:
            return ProgressInfo(progressNumber: 1, progressIndex: 3); // 3-3
        case .returned,
             .cancelling,
             .canceled:
            return ProgressInfo(progressNumber: 3, progressIndex: 4); // 3-4
        }
    }
}

struct ProgressInfo {
    var progressNumber: Int?
    var progressIndex: Int?

    init(progressNumber: Int? = nil, progressIndex: Int? = nil) {
        self.progressNumber = progressNumber
        self.progressIndex = progressIndex
    }
}

enum EgiftRewardStatus: String {
    case used = "U"
    case expired = "E"
    case redeemed = "R"
}

enum WhyHaveRewardType: String {
    case sent = "SENT"
    case bought = "BOUGHT"
    case received = "RECEIVED"
    
    static let allValues = [sent, bought, received]
}

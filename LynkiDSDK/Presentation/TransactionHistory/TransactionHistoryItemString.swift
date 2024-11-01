//
//  TransactionHistoryItemString.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 04/06/2024.
//

import Foundation
import UIKit

struct TransactionHistoryItemString {
    static let shared = TransactionHistoryItemString()

    func isPrime(_ actionCodeDetail: String?) -> Bool {
        let baseUrl = EnvConfig.shared.baseUrl
        let codes = baseUrl.contains("uat") ? ["C|472", "C|484", "C|467", "C|468", "C|469"] : ["C|427", "C|449", "C|451", "C|425", "C|445"]
        return codes.contains { code in
            (actionCodeDetail ?? "").hasPrefix(code + "|") || (actionCodeDetail ?? "") == code
        }
    }

    func isDiamond(_ actionCodeDetail: String?) -> Bool {
        let baseUrl = EnvConfig.shared.baseUrl
        let codes = baseUrl.contains("uat") ? ["C|475", "C|476", "C|477", "C|478", "C|498", "C|480", "C|496", "C|481", "C|473"] : ["C|427", "C|449", "C|451", "C|425", "C|445"]
        return codes.contains { code in
            (actionCodeDetail ?? "").hasPrefix(code + "|") || (actionCodeDetail ?? "") == code
        }
    }


    func returnLogo(merchants: [MerchantModel]?, pointHistory: TransactionItem) -> String? {
        guard let merchants = merchants else { return nil }
        for merchant in merchants {
            if merchant.id == pointHistory.merchantId {
                if let storeName = pointHistory.storeName, !storeName.isEmpty {
                    for store in merchant.storeList ?? [] {
                        if store.id == pointHistory.storeId {
                            return store.avatar ?? ""
                        }
                    }
                } else {
                    return merchant.logo ?? ""
                }
            }
        }
        return nil
    }


    func isScriptedCampaign(_ actionCodeDetail: String?) -> Bool {
        if(actionCodeDetail?.split(separator: "|").count ?? 0 > 1) {
            let campaignId = actionCodeDetail?.split(separator: "|")[1] ?? ""
            return UserDefaults.standard.string(forKey: "C|\(campaignId)_title")?.isEmpty == false
        }
        return false

    }

    func handlePointHistoryImage(merchants: [MerchantModel]?, pointHistory: TransactionItem, forceContent: String) -> String? {
        if isScriptedCampaign(pointHistory.actionCodeDetail) {
            let campaignId = pointHistory.actionCodeDetail!.split(separator: "|")[1]
            return UserDefaults.standard.string(forKey: "C|\(campaignId)_logo") ?? returnLogo(merchants: merchants, pointHistory: pointHistory)
        }
        if isPrime(pointHistory.actionCodeDetail) {
            return "ic_prime"
        }
        if isDiamond(pointHistory.actionCodeDetail) {
            return "ic_diamond"
        }
        if !forceContent.isEmpty {
            return returnLogo(merchants: merchants, pointHistory: pointHistory) ?? "ic_app_placeholder"
        }

        switch pointHistory.actionType {
        case "Exchange":
            return returnLogo(merchants: merchants, pointHistory: pointHistory) ?? "ic_app_placeholder"
        case "Adjust":
            return "ic_app_placeholder"
        case "Action":
            switch pointHistory.actionCode {
            case "Adjust":
                return returnLogo(merchants: merchants, pointHistory: pointHistory)
            case "MemoryLand":
                return returnLogo(merchants: merchants, pointHistory: pointHistory)
            case "Birthday":
                return "ic_birthday"
            case "Custom":
                return "ic_event"
            case "ClaimQuest":
                return "ic_quest"
            case "ClaimMission":
                return "ic_mission"
            case "ActionRule":
                return returnLogo(merchants: merchants, pointHistory: pointHistory)
            case "Referee",
                 "Referrer":
                return "ic_app_placeholder"
            default:
                return "ic_app_placeholder"

            }
        case "BatchManualGrant",
             "SingleManualGrant":
            return "ic_app_placeholder"
        case "TopUp":
            return "ic_app_placeholder"
        case "Expired":
            return "ic_expired"
        case "Redeem":
            return "ic_app_placeholder"
        case "PayByToken":
            return returnLogo(merchants: merchants, pointHistory: pointHistory) ?? "ic_app_placeholder"
        case "Transfer":
            return "ic_app_placeholder"
        case "ReturnFull",
             "ReturnPartial",
             "Revert",
             "RevertOrder":
            return returnLogo(merchants: merchants, pointHistory: pointHistory)
        case "AdjustPlus",
             "CreditBalance":
            return returnLogo(merchants: merchants, pointHistory: pointHistory)
        case "CashedOut",
             "CashedOutFee",
             "Claim",
             "RevertExchange",
             "AdjustMinus",
             "Deposit",
             "RevertCashOut",
             "RevertCashOutFee":
            return "ic_app_placeholder"
        case "Order":
            return returnLogo(merchants: merchants, pointHistory: pointHistory)

        default: return "ic_app_placeholder"

        }
    }

    func normalTextStyle() -> [NSAttributedString.Key: Any] {
        let style: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.c030319!, .font: UIFont.f14r!]
        return style
    }


    func boldTextStyle() -> [NSAttributedString.Key: Any] {
        let style: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.c030319!, .font: UIFont.f14s!]
        return style
    }


    func primeTextStyle() -> [NSAttributedString.Key: Any] {
        let style: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.c0061A0!, .font: UIFont.f14s!]
        return style
    }


    static func diamondTextStyle() -> [NSAttributedString.Key: Any] {
        let style: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.cB67924!, .font: UIFont.f14s!]
        return style
    }


    func customText(color: String) -> [NSAttributedString.Key: Any] {
        let style: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.init(named: "#" + color)!, .font: UIFont.f14s!]
        return style
    }

    func isShowExtraDetail(pointHistoryItem: TransactionItem) -> Bool {
        switch pointHistoryItem.actionType {
        case "Exchange":
            return true

        case "PayByToken", "SingleManualGrant", "BatchManualGrant", "Order", "CashedOut", "CashedOutFee", "AdjustPlus", "Claim", "RevertExchange", "Deposit", "RevertCashOut", "AdjustMinus", "RevertCashOutFee":
            return false

        case "Adjust", "Redeem", "Transfer", "ReturnFull", "ReturnPartial", "Revert", "RevertOrder", "Action", "TopUp", "Expired", "CreditBalance":
            return false

        default:
            return false
        }
    }


    func handlePointHistoryPrimeType(pointHistoryItem: TransactionItem) -> String {
        let baseUrl = EnvConfig.shared.baseUrl
        if baseUrl.contains("uat") || baseUrl.contains("-pre") {
            if pointHistoryItem.actionCodeDetail?.starts(with: "C|472") ?? false {
                return "Điều chỉnh điểm từ VPBank Prime"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|484") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|467") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|468") ?? false {
                return "Quà tặng gắn kết từ VPBank Prime"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|469") ?? false {
                return "Quà tặng sinh nhật từ VPBank Prime"
            }
        } else {
            if pointHistoryItem.actionCodeDetail?.starts(with: "C|445") ?? false {
                return "Điều chỉnh điểm từ VPBank Prime"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|427") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|449") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|451") ?? false {
                return "Quà tặng gắn kết từ VPBank Prime"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|425") ?? false {
                return "Quà tặng sinh nhật từ VPBank Prime"
            }
        }
        return "Số dư điểm LynkiD thay đổi"
    }

    func handlePointHistoryDiamondType(pointHistoryItem: TransactionItem) -> String {
        let baseUrl = EnvConfig.shared.baseUrl
        if baseUrl.contains("uat") || baseUrl.contains("-pre") {
            if pointHistoryItem.actionCodeDetail?.starts(with: "C|475") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|476") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|477") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|478") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|498") ?? false {
                return "Tích điểm từ VPBank Diamond"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|480") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|496") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|481") ?? false {
                return "Quà tặng từ VPBank Diamond"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|473") ?? false {
                return "Chuyển đổi điểm từ VPBank Loyalty"
            }
        } else {
            if pointHistoryItem.actionCodeDetail?.starts(with: "C|475") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|476") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|477") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|478") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|498") ?? false {
                return "Tích điểm từ VPBank Diamond"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|480") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|496") ?? false ||
                pointHistoryItem.actionCodeDetail?.starts(with: "C|481") ?? false {
                return "Quà tặng từ VPBank Diamond"
            } else if pointHistoryItem.actionCodeDetail?.starts(with: "C|473") ?? false {
                return "Chuyển đổi điểm từ VPBank Loyalty"
            }
        }
        return "Số dư điểm LynkiD thay đổi"
    }

    func handlePointHistoryType(pointHistoryItem: TransactionItem) -> String {
        if isScriptedCampaign(pointHistoryItem.actionCodeDetail) {
            let campaignId = pointHistoryItem.actionCodeDetail?.split(separator: "|")[1] ?? ""
            return UserDefaults.standard.string(forKey: "C|\(campaignId)_title") ?? ""
        }
        if isPrime(pointHistoryItem.actionCodeDetail) {
            return handlePointHistoryPrimeType(pointHistoryItem: pointHistoryItem)
        }
        if isDiamond(pointHistoryItem.actionCodeDetail) {
            return handlePointHistoryDiamondType(pointHistoryItem: pointHistoryItem)
        }
        switch pointHistoryItem.actionType {
        case "Exchange":
            return "Đổi điểm với đối tác \(pointHistoryItem.fromMerchantNameOrMember!)"
        case "Adjust":
            return "Điều chỉnh giao dịch"
        case "Action":
            switch pointHistoryItem.actionCode {
            case "Adjust":
                return "Cấp điểm từ \(pointHistoryItem.fromMerchantNameOrMember!)"
            case "Birthday":
                return "\(pointHistoryItem.fromMerchantNameOrMember!) chúc mừng sinh nhật bạn"
            case "Custom":
                // Assuming additional context is provided elsewhere for event name
                return "Quà tặng từ LynkiD"
            case "ClaimQuest":
                // Assuming additional context is provided elsewhere for challenge name
                return "Nhận điểm từ thử thách"
            case "ClaimMission":
                // Assuming additional context is provided elsewhere for mission name
                return "Nhận điểm từ nhiệm vụ"
            case "MemoryLand":
                switch pointHistoryItem.actionCodeDetail {
                case "ReadNews":
                    return "Kỷ niệm đọc báo"
                case "FirstLogin":
                    return "Kỷ niệm đăng nhập lần đầu"
                case "DailyLogin":
                    return "Kỷ niệm đăng nhập hàng ngày"
                default:
                    return "Quà tặng từ \(pointHistoryItem.fromMerchantNameOrMember!)"
                }
            case "ActionRule":
                switch pointHistoryItem.actionCodeDetail {
                case "ReadNews":
                    return "Tặng điểm đọc báo"
                case "FirstLogin":
                    return "Tặng điểm đăng nhập lần đầu"
                case "DailyLogin":
                    return "Tặng điểm đăng nhập hàng ngày"
                case "PayByToken":
                    return "Hoàn điểm cho chi tiêu tại \(pointHistoryItem.fromMerchantNameOrMember!)"
                case "Redeem":
                    return "Tặng điểm hành động đổi quà"
                case "1stPayByQR":
                    return "Hoàn điểm cho chi tiêu lần đầu tại \(pointHistoryItem.fromMerchantNameOrMember!)"
                case "Exchange":
                    return "Tặng điểm hành động đổi điểm"
                case "ConnectMerchant":
                    return "Tặng điểm kết nối đối tác lần đầu"
                case "MLMAction":
                    return "Tặng điểm đơn hàng đa cấp"
                default:
                    return "Tích điểm từ \(pointHistoryItem.fromMerchantNameOrMember!)"
                }
            case "Referee":
                return "Nhận thưởng hoa hồng từ CT Giới thiệu bạn bè"
            case "Referrer":
                return "Nhận thưởng hoa hồng từ CT Giới thiệu bạn bè"
            default:
                return "Số dư điểm LynkiD thay đổi"
            }
        case "BatchManualGrant", "SingleManualGrant":
            return "Điểm thưởng từ \(pointHistoryItem.fromMerchantNameOrMember!)"
        case "TopUp":
            return "Nạp tiền thành công"
        case "Expired":
            return "Điều chỉnh điểm từ LynkiD"
        case "Redeem":
            return "Đổi quà tại LynkiD"
        case "PayByToken":
            let merchant = (pointHistoryItem.storeName ?? "").isEmpty ? pointHistoryItem.toMerchantNameOrMember : pointHistoryItem.storeName
            return "Tiêu điểm tại \(merchant ?? "")"
        case "Transfer":
            return "Nhận điểm từ \(pointHistoryItem.fromMerchantNameOrMember!)"
        case "ReturnFull", "ReturnPartial", "RevertOrder":
            return "Giao dịch thu hồi điểm tại \(pointHistoryItem.toMerchantNameOrMember ?? "")"
        case "Revert":
            return "Hoàn điểm do giao dịch thất bại tại \(pointHistoryItem.fromMerchantNameOrMember!)"
        case "CashedOut":
            return "CashedOut từ LynkiD"
        case "CashedOutFee":
            return "CashedOutFee từ LynkiD"
        case "AdjustPlus":
            return "Cấp điểm từ \(pointHistoryItem.fromMerchantNameOrMember!)"
        case "Claim":
            return "Claim từ LynkiD"
        case "RevertExchange":
            return "Điều chỉnh điểm từ \(pointHistoryItem.toMerchantNameOrMember ?? "")"
        case "Deposit":
            return "Deposit từ LynkiD"
        case "RevertCashOut":
            return "RevertCashOut từ LynkiD"
        case "AdjustMinus":
            return "Thu hồi điểm của \(pointHistoryItem.toMerchantNameOrMember ?? "")"
        case "RevertCashOutFee":
            return "RevertCashOutFee từ LynkiD"
        case "Order":
            return "Tích điểm từ \(pointHistoryItem.fromMerchantNameOrMember!)"
        case "Topup":
            return "Nhận điểm thành công"
        case "CreditBalance":
            return "Điều chỉnh điểm từ \(pointHistoryItem.toMerchantNameOrMember ?? "")"
        default:
            return "Số dư điểm LynkiD thay đổi"

        }
    }
}



//
//  FlashSaleCountDownTimer.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 09/07/2024.
//

import Foundation
import RxSwift
import RxRelay

class FlashSale {

    static let shared = FlashSale()
    private init() { }

    var timer: Timer?
    var giftInfo: GiftInfoItem?
    var totalTime = BehaviorRelay<Int>(value: 0)
    var flashSaleStatus = BehaviorRelay<FlashSaleStatus>(value: .none)


    func setupData(_ giftInfo: GiftInfoItem?) {
        self.giftInfo = giftInfo
        handleStatus()
        startOtpTimer()
    }

    private func startOtpTimer() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }

    func resetTimer(totalTime: Int) {
        stopTimmer()
        startOtpTimer()
        self.totalTime.accept(totalTime)
    }

    func stopTimmer() {
        timer?.invalidate()
        timer = nil
        self.totalTime.accept(0)
    }

    func stopFlashSale() {
        flashSaleStatus.accept(.none)
        totalTime.accept(0)
        stopTimmer()
    }

    @objc func updateTimer() {
        var _totalTime = self.totalTime.value
        if _totalTime != 0 {
            _totalTime -= 1 // decrease counter timer
            self.totalTime.accept(_totalTime)
        } else {
            stopFlashSale()
        }
    }

    func handleStatus() {
        let flashSaleProgramInfor = giftInfo?.flashSaleProgramInfor

        if flashSaleProgramInfor == nil ||
            flashSaleProgramInfor?.code == nil ||
            flashSaleProgramInfor?.status == "I" {
            flashSaleStatus.accept(.none)
            return
        }
        let currentDate = Date().toLocalTime()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatterType.yyyyMMddThhmmss.value
        if let startDate = dateFormatter.date(from: flashSaleProgramInfor?.startTime ?? ""),
            let endDate = dateFormatter.date(from: flashSaleProgramInfor?.endTime ?? "") {
            let diffStartCurrent = Int(startDate.timeIntervalSince(currentDate))
            let diffEndCurrent = Int(endDate.timeIntervalSince(currentDate))
            if (diffStartCurrent > 0) {
                flashSaleStatus.accept(.upcoming_flash_sale)
                totalTime.accept(diffStartCurrent)
            } else if (diffEndCurrent > 0) {
                flashSaleStatus.accept(.in_flash_sale)
                totalTime.accept(diffEndCurrent)
            } else {
                stopFlashSale()
            }
        } else {
            stopFlashSale()
        }
    }

    func calculateTimeDifference(startDate: Date, endDate: Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: startDate, to: endDate)
        return components
    }

    var getHours: String {
        let hours: Int = totalTime.value / 3600
        return String(format: "%02d", hours)
    }

    var getMinutes: String {
        let minutes: Int = (totalTime.value / 60) % 60
        return String(format: "%02d", minutes)
    }

    var getSeconds: String {
        let seconds: Int = totalTime.value % 60
        return String(format: "%02d", seconds)
    }

    var isShowFlashSale: Bool {
        return self.flashSaleStatus.value != .none && remainingQuantityOfTheGift > 0
    }

    var remainingQuantityOfTheGift: Int {
        let remainingFlashSale = giftInfo?.giftDiscountInfor?.remainingQuantityFlashSale
        let remainingGift = giftInfo?.giftInfor?.remainingQuantity
        return remainingFlashSale ?? remainingGift ?? 0
    }

    var getGiftRemaningTitle: String {
        let giftDiscountInfor = giftInfo?.giftDiscountInfor
        let warningOutOfStock = giftDiscountInfor?.warningOutOfStock ?? false
        if self.flashSaleStatus.value == .in_flash_sale && warningOutOfStock {
            return "Sắp cháy hàng (\(remainingQuantityOfTheGift))"
        }
        return "Còn lại (\(remainingQuantityOfTheGift))"
    }

    var getGiftStatusTitle: String {
        if flashSaleStatus.value == .in_flash_sale {
            return "Kết thúc sau"
        }
        return "Sắp diễn ra"
    }
}

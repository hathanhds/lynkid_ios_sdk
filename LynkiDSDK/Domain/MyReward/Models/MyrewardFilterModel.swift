//
//  MyrewardFilterModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/05/2024.
//

import Foundation



class MyrewardFilterModel {
    var giftType: OptionModel?
    var status: OptionModel?
    var presentType: OptionModel?


    init(giftType: OptionModel? = nil, status: OptionModel? = nil, presentType: OptionModel? = nil) {
        self.giftType = giftType
        self.status = status
        self.presentType = presentType
    }

    static var giftTypes: [OptionModel] {
        return [
            OptionModel(id: "EGift", title: "Voucher"),
            OptionModel(id: "PhysicalGift", title: "Quà hiện vật")
        ]
    }


    struct MyOwnedReward {
        static var status: [OptionModel] {
            return [
                OptionModel(id: "IsNearExpire", title: "Sắp hết hạn")
            ]
        }

        static var presentTypes: [OptionModel] {
            return [
                OptionModel(id: "ReceivedGift", title: "Được tặng")
            ]
        }
    }

    struct MyUsedReward {
        static var status: [OptionModel] {
            return [
                OptionModel(id: "U", title: "Đã sử dụng"),
                OptionModel(id: "E", title: "Hết hạn")
            ]
        }


        static var presentTypes: [OptionModel] {
            return [
                OptionModel(id: "ReceivedGift", title: "Được tặng"),
                OptionModel(id: "SendableGift", title: "Đã tặng")
            ]
        }
    }
}



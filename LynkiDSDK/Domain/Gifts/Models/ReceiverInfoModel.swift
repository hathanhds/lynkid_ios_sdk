//
//  ReceiverInfoModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 24/06/2024.
//

import Foundation

struct ReceiverInfoModel: Codable {
    var name: String?
    var phoneNumber: String?
    var city: LocationModel?
    var district: LocationModel?
    var ward: LocationModel?
    var detailAddress: String?
    var note: String?

    init(name: String? = nil, phoneNumber: String? = nil, city: LocationModel? = nil, district: LocationModel? = nil, ward: LocationModel? = nil, detailAddress: String? = nil, note: String? = nil) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.city = city
        self.district = district
        self.ward = ward
        self.detailAddress = detailAddress
        self.note = note
    }

    func getFullAddress() -> String {
        var arrary = [String]()
        if let detailAddress = detailAddress {
            arrary.append(detailAddress)
        }
        if let ward = ward, let name = ward.name {
            arrary.append(name)
        }
        if let district = district, let name = district.name {
            arrary.append(name)
        }
        if let city = city, let name = city.name {
            arrary.append(name)
        }
        if !arrary.isEmpty {
            return arrary.joined(separator: ", ")
        }
        return ""
    }

    func receiverRequest() -> ReceiverInfoRequest {
        return ReceiverInfoRequest(
            fullname: name,
            phone: phoneNumber,
            cityId: city?.code,
            districtId: district?.code,
            wardId: ward?.code,
            shipAddress: detailAddress,
            note: note
        )
    }
}
struct ReceiverInfoRequest: Codable {
    var fullname: String?
    var phone: String?
    var cityId: String?
    var districtId: String?
    var wardId: String?
    var shipAddress: String?
    var note: String?

    init(fullname: String? = nil, phone: String? = nil, cityId: String? = nil, districtId: String? = nil, wardId: String? = nil, shipAddress: String? = nil, note: String? = nil) {
        self.fullname = fullname
        self.phone = phone
        self.cityId = cityId
        self.districtId = districtId
        self.wardId = wardId
        self.shipAddress = shipAddress
        self.note = note
    }

}

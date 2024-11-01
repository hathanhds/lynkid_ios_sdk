//
//  ShippingLocationArguments.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 10/07/2024.
//

import Foundation

struct ShippingLocationArguments {
    var locationType: LocationType
    var locations: [LocationModel]
    var title: String
    var callBack: (_ location: LocationModel) -> Void
    init(locationType: LocationType, locations: [LocationModel], title: String, callBack: @escaping (_ location: LocationModel) -> Void) {
        self.locationType = locationType
        self.locations = locations
        self.title = title
        self.callBack = callBack
    }
}

//
//  TopupDataSyntaxModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 26/08/2024.
//

import Foundation

// {"PrePaid": "*100*1234354545#", "PostPaid": "*199*0*1221212#"}

struct TopupDataSyntaxModel: Codable {
    var syntax: String?
    var toNumber: String?

    init(syntax: String? = nil, toNumber: String? = nil) {
        self.syntax = syntax
        self.toNumber = toNumber
    }

    private enum CodingKeys: String, CodingKey {
        case syntax = "Syntax"
        case toNumber = "ToNumber"
    }

    func fromJson(json: String) -> TopupDataSyntaxModel? {
        if let jsonData = json.data(using: .utf8), let model = try? jsonData.decoded(type: TopupDataSyntaxModel.self) {
            return model
        }
        return nil
    }
}

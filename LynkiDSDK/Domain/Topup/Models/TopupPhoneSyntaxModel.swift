//
//  TopupSyntaxModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 26/08/2024.
//

import Foundation

// {"PrePaid": "*100*1234354545#", "PostPaid": "*199*0*1221212#"}

struct TopupPhoneSyntaxModel: Codable {
    var prePaid: String?
    var postPaid: String?

    init(prePaid: String? = nil, postPaid: String? = nil) {
        self.prePaid = prePaid
        self.postPaid = postPaid
    }

    private enum CodingKeys: String, CodingKey {
        case prePaid = "PrePaid"
        case postPaid = "PostPaid"
    }

    func fromJson(json: String) -> TopupPhoneSyntaxModel? {
        if let jsonData = json.data(using: .utf8), let model = try? jsonData.decoded(type: TopupPhoneSyntaxModel.self) {
            return model
        }
        return nil
    }
}

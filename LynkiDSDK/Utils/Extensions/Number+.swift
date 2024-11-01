//
//  Decimal+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 31/01/2024.
//

import Foundation

extension Double {
    func formatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        if let str = numberFormatter.string(for: fabs(self) as NSNumber) {
            return str
        }
        return ""
    }
}

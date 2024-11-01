//
//  UIColor+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//

import UIKit

extension UIColor {

    convenience init?(hex: String) {
        var chars = Array(hex.hasPrefix("#") ? hex.dropFirst() : hex[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars = ["F", "F"] + chars
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
            green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
            blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
            alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }

}

extension UIColor {

    static let mainColor = UIColor(hex: "#663692")
    static let shimmerColor = UIColor(hex: "#A7A7B3")
    static let diamondColor = UIColor(hex: "#E9B161")
    static let diamondBgColor = UIColor(hex: "#1F1F1F")

    static let coinColor = UIColor(hex: "#F2994A")
    static let c621FA0 = UIColor(hex: "#621FA0")
    static let c333333 = UIColor(hex: "#333333")
    static let c837E85 = UIColor(hex: "#837E85")
    static let cA7A7B3 = UIColor(hex: "#A7A7B3")
    static let c591C90 = UIColor(hex: "#591C90")
    static let c971ACC = UIColor(hex: "#971ACC")
    static let c6D6B7A = UIColor(hex: "#6D6B7A")
    static let cD8D6DD = UIColor(hex: "#D8D6DD")
    static let cEFEFF6 = UIColor(hex: "#EFEFF6")
    static let cF0F0F4 = UIColor(hex: "#F0F0F4")
    static let cE6E6E6 = UIColor(hex: "#E6E6E6")
    static let c4A2497 = UIColor(hex: "#4A2497")
    static let cF8FAFC = UIColor(hex: "#F8FAFC")
    static let cFFF8EB = UIColor(hex: "#FFF8EB")
    static let cFFE9B4 = UIColor(hex: "#FFE9B4")
    static let cFFCC00 = UIColor(hex: "#FFCC00")
    static let cFFB400 = UIColor(hex: "#FFB400")
    static let c6CF399 = UIColor(hex: "#6CF399")
    static let c1DB24E = UIColor(hex: "#1DB24E")
    static let c34C759 = UIColor(hex: "#34C759")
    static let c837D84 = UIColor(hex: "#837D84")
    static let c007AFF = UIColor(hex: "#007AFF")
    static let cFF7990 = UIColor(hex: "#FF7990")
    static let cF4E8FF = UIColor(hex: "#F4E8FF")
    static let cFFFF00 = UIColor(hex: "#FFFF00")
    static let c242424 = UIColor(hex: "#242424")
    static let cEFE7F6 = UIColor(hex: "#EFE7F6")
    static let cF1EBF6 = UIColor(hex: "#F1EBF6")
    static let cFFD10F = UIColor(hex: "#FFD10F")
    static let cFE9E32 = UIColor(hex: "#FE9E32")
    static let cFFAD33 = UIColor(hex: "#FFAD33")
    static let cF5574E = UIColor(hex: "#F5574E")
    static let c663692 = UIColor(hex: "#663692")
    static let c030319 = UIColor(hex: "#030319")
    static let c0061A0 = UIColor(hex: "#0061A0")
    static let cB67924 = UIColor(hex: "#B67924")
    static let c47372B = UIColor(hex: "#47372B")
    static let c0F0F0F = UIColor(hex: "#0F0F0F")
    static let c332D2E = UIColor(hex: "#332D2E")
    static let c261F28 = UIColor(hex: "#261F28")
    static let c92653E = UIColor(hex: "#92653E")
    static let cD4A666 = UIColor(hex: "#D4A666")
    static let cE9B161 = UIColor(hex: "#E9B161")
    static let c524C4D = UIColor(hex: "#524C4D")
    static let cFFD833 = UIColor(hex: "#FFD833")
    static let c37363A = UIColor(hex: "#37363A")
    static let c450079 = UIColor(hex: "#450079")
    static let c242021 = UIColor(hex: "#242021")
    static let c171514 = UIColor(hex: "#171514")
    static let cFF3D5C = UIColor(hex: "#FF3D5C")
}

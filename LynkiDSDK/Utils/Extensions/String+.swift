//
//  String+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 11/03/2024.
//

import Foundation
import UIKit

extension String {
    func containsAlphabetLetters() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsLowercaseLetter() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsUppercaseLetter() -> Bool {
        let set = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsAtLeastOne(from string: String) -> Bool {
        let set = CharacterSet(charactersIn: string)
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }

    func containsSpecialCharacters(exceptions: [String] = []) -> Bool {
        guard self.count > 0 else { return false }
        var text = self
        exceptions.forEach({ text = text.replacingOccurrences(of: $0, with: "") })
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            return regex.firstMatch(in: text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, text.count)) != nil
        } catch {
            debugPrint(error.localizedDescription)
        }
        return false
    }

    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

}

extension String {
    func currencyFomatter() -> String {
        var amountWithPrefix = self
        if (amountWithPrefix.isEmpty) {
            return ""
        }
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        let double = (amountWithPrefix as NSString).doubleValue
        return double.formatter()
    }

    func phoneNumberFormatter() -> String {
        return self.applyPatternOnNumbers(pattern: "#### ### ### ###", replacmentCharacter: "#")
    }

    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }

    func formatVietnamesePhoneNumber() -> String {
        let digits = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let number = digits.removeLeadingZeros()
        if number.hasPrefix("84") {
            return "+84" + String(number.dropFirst(2))
        } else if number.hasPrefix("+84") {
            return number
        } else {
            return "+84" + number
        }
    }
    
    func formatPhoneWithoutZone() -> String {
        return "0\(self.suffix(9))"
    }

    func removeLeadingZeros() -> String {
        var result = self
        while result.hasPrefix("0") && result.count > 1 {
            result = String(result.dropFirst())
        }
        return result
    }

    func maskedString() -> String {
        return "*** *** " + self.suffix(4)
    }

    func isWebURL() -> Bool {
        guard let url = URL(string: self), let scheme = url.scheme, let _ = url.host else {
            return false
        }
        return ["http", "https"].contains(scheme.lowercased())
    }

}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

}

extension String {
    func replacingLastCharacters(with replacement: String, numberOfReplacedCharacters: Int = 4) -> String {
        guard self.count >= numberOfReplacedCharacters else {
            // If the string is shorter than 4 characters, return the replacement string
            return replacement
        }

        let endIndex = self.endIndex
        let startIndex = self.index(endIndex, offsetBy: -numberOfReplacedCharacters)
        let range = startIndex..<endIndex

        let newString = self.replacingCharacters(in: range, with: replacement)
        return newString
    }
}

extension String {
    func truncated(to length: Int, addEllipsis: Bool = false) -> String {
        if self.count > length {
            let endIndex = self.index(self.startIndex, offsetBy: length)
            let truncatedString = self[..<endIndex]
            return addEllipsis ? "\(truncatedString)..." : String(truncatedString)
        } else {
            return self
        }
    }
}

extension String {
    
    func removingSpecialCharacters() -> String {
        let pattern = "[^a-zA-Z0-9]"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: " ")
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            return self
        }
    }

    func removeDiacritics() -> String {
        if self.isEmpty {
            return self
        }
        var string = self.replacingOccurrences(of: "[à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ]", with: "a", options: [.regularExpression])
        string = string.replacingOccurrences(of: "[è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ]", with: "e", options: [.regularExpression])
        string = string.replacingOccurrences(of: "[ì|í|ị|ỉ|ĩ]", with: "i", options: [.regularExpression])
        string = string.replacingOccurrences(of: "[ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ]", with: "o", options: [.regularExpression])
        string = string.replacingOccurrences(of: "[ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ]", with: "u", options: [.regularExpression])
        string = string.replacingOccurrences(of: "[ỳ|ý|ỵ|ỷ|ỹ]", with: "y", options: [.regularExpression])
        string = string.replacingOccurrences(of: "[đ]", with: "y", options: [.regularExpression])
        return string.lowercased()
    }
}

extension NSAttributedString {
    func applyFontAndColor(_ font: UIFont = .f14r ?? .systemFont(ofSize: 14), _ color: UIColor = .c242424 ?? .black) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)

        mutableAttributedString.beginEditing()
        mutableAttributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length), options: []) { (value, range, stop) in
            if let _ = value as? UIFont {
                mutableAttributedString.addAttribute(.font, value: font, range: range)
                mutableAttributedString.addAttribute(.foregroundColor, value: color, range: range)
            }
        }
        mutableAttributedString.endEditing()

        return mutableAttributedString
    }
}

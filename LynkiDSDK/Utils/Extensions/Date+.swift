//
//  Date+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 06/02/2024.
//

import Foundation

enum DateFormatterType {
    case ddMMyyyy
    case yyyyMMdd
    case yyyyMMddThhmmss
    case yyyyMMddThhmmssSSZ
    case HHmmddMMyyyy
    case HHmm_ddMM
    case HHmm_ddMMYYYY

    var value: String {
        switch(self) {
        case .ddMMyyyy:
            return "dd/MM/yyyy"
        case .yyyyMMdd:
            return "yyyy-MM-dd"
        case .yyyyMMddThhmmss:
            return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .yyyyMMddThhmmssSSZ:
            return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .HHmmddMMyyyy:
            return "HH:mm - dd/MM/yyyy"
        case .HHmm_ddMM:
            return "HH:mm - dd/MM"
        case .HHmm_ddMMYYYY:
            return "HH:mm - dd/MM/yyyy"
        }
    }
}

extension Date {

    init?(fromString string: String, formatter: DateFormatterType) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter.value
        if let date = dateFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    func toString(formatter: DateFormatterType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter.value
        return dateFormatter.string(from: self)
    }

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
            return Int64(self.timeIntervalSince1970 * 1000)
        }
}

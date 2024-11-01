//
//  AppUserDefaults.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/06/2024.
//

import Foundation

struct AppUserDefaults {
    static func valueForKey(_ key: AppUserDefaultKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }

    static func setValue(_ value: Any?, forKey key: AppUserDefaultKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    static func removeValue(_ key: AppUserDefaultKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    static func saveListObject<T:Codable>(_ list: [T], type: T.Type, forKey key: AppUserDefaultKey) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
    }

    static func getListObject<T:Codable>(_ key: AppUserDefaultKey, type: T.Type) -> [T]? {
        if let savedData = UserDefaults.standard.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            if let loadedList = try? decoder.decode([T].self, from: savedData) {
                return loadedList
            }
        }
        return nil
    }
}

enum AppUserDefaultKey: String {
    case userPointLynkID
    case userIdLynkID
    case categoriesLynkID
    case diamondCateCodeLynkID
}

extension AppUserDefaults {
    static var userPoint: Double {
        get {
            if let userPoint = AppUserDefaults.valueForKey(.userPointLynkID) as? Double {
                return userPoint
            } else {
                return 0
            }
        } set {
            AppUserDefaults.setValue(newValue, forKey: .userPointLynkID)
        }
    }

    static var userId: Int {
        get {
            if let userId = AppUserDefaults.valueForKey(.userIdLynkID) as? Int {
                return userId
            } else {
                return 0
            }
        } set {
            AppUserDefaults.setValue(newValue, forKey: .userIdLynkID)
        }
    }

    static var categories: [GiftCategory] {
        get {
            if let categories = AppUserDefaults.getListObject(.categoriesLynkID, type: GiftCategory.self) {
                let displayCates = categories.filter { !$0.isCashOut }
                return displayCates
            } else {
                return []
            }
        }
        set {
            AppUserDefaults.saveListObject(newValue, type: GiftCategory.self, forKey: .categoriesLynkID)
        }
    }

    static var diamondCateCode: String {
        get {
            if let diamondCateCode = AppUserDefaults.valueForKey(.diamondCateCodeLynkID) as? String {
                return diamondCateCode
            } else {
                return ""
            }
        } set {
            AppUserDefaults.setValue(newValue, forKey: .diamondCateCodeLynkID)
        }
    }

}

//
//  EnvConfig.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 17/01/2024.
//

import Foundation

enum Env {
    case uat, stage, prod

    static var current: Env {
        #if PROD
            return .prod
        #elseif STAGE
            return .stage
        #else
            return .uat
        #endif
    }
}

class EnvConfig {
    static let shared = EnvConfig()

    var baseUrl: String = ""
    var appName: String = ""
    var env: Env = Env.uat

    private init() {
        var conf: [String: Any]?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            conf = NSDictionary(contentsOfFile: path) as! [String: Any]?
        }

        if let conf = conf {
            if let baseUrl = conf["BASE_URL"] as? String {
                self.baseUrl = baseUrl
            }
            if let name = conf["PRODUCT_NAME"] as? String {
                self.appName = name
            }
        }
        self.env = Env.current
    }
}

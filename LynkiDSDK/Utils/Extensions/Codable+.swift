//
//  Encodable.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 19/02/2024.
//

import Foundation

extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func toJsonString() -> String {
        if let data = try? JSONEncoder().encode(self), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return ""
    }
}

extension Data {
    func decoded<T: Decodable>(type: T.Type) throws -> T {
        do {
            let model = try JSONDecoder().decode(T.self, from: self)
        } catch {
            print("Failed to decode: \(error)")
        }
        return try JSONDecoder().decode(T.self, from: self)
    }
}



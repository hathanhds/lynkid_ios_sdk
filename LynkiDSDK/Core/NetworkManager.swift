//
//  NetworkManager.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 17/01/2024.
//

import Alamofire


struct NetworkManager {
    static let shared = NetworkManager()
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    func startListening() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                NotificationCenter.dispatch(name: .networkIsNotConnected)
                print("The network 🔴")
            case .reachable(_):
                NotificationCenter.dispatch(name: .networkIsConnected)
                print("The network 🔵")
            case .unknown:
                break
            }
        }
    }
    func stopListening() {
        reachabilityManager?.stopListening()
    }

    var isNetworkconnected: Bool {
        return reachabilityManager?.isReachable ?? false
    }

    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if let networkManage = NetworkManager.shared.reachabilityManager, networkManage.isReachable {
            completed(NetworkManager.shared)
        }
    }

    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if let networkManage = NetworkManager.shared.reachabilityManager, !networkManage.isReachable {
            completed(NetworkManager.shared)
        }
    }
}

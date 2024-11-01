//
//  AppHelper.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 17/01/2024.
//

import Alamofire

class AlamofireLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️ Request Started: \(request)
        ⚡️ Body Data: \(body)
        """
        NSLog(message)
    }

    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        NSLog("⚡️ Response Received: \(response.debugDescription)")
    }

}

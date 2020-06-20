//
//  ReadQRCodeService.swift
//  TestRealm
//
//  Created by Le.Sang on 2020/06/19.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol ReadQRResultService {
    func readQRResultHandler() -> ReadQRResult
}

public class ReadQRResultServiceImp: ReadQRResultService {
    public let resultSrting: String

    init(result: String) {
        self.resultSrting=result
    }

    struct QRResult: Codable {
        let companyId: String
        let siteId: String
        let clientId: String
        let clientSecret: String
    }

    public func readQRResultHandler() -> ReadQRResult {
        do {
            let jsonDecoder = JSONDecoder()

            guard let resultData = resultSrting.data(using: .utf8) else {
                return ReadQRResult(resultCode: ReadQRResultCode.fail, companyId: "", siteId: "", clientId: "", clientSecret: "")
            }

            let result = try jsonDecoder.decode(QRResult.self, from: resultData)

            return ReadQRResult(resultCode: ReadQRResultCode.ok, companyId: result.companyId, siteId: result.siteId, clientId: result.clientId, clientSecret: result.clientSecret)
        } catch {
            return ReadQRResult(resultCode: ReadQRResultCode.fail, companyId: "", siteId: "", clientId: "", clientSecret: "")
        }
    }
}

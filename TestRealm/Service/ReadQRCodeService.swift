//
//  ReadQRCodeService.swift
//  TestRealm
//
//  Created by Le.Sang on 2020/06/19.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

/// RawQRResult
///
/// - Parameters:
///   - resultString: The Raw String from QRScanner
///   - errorCode: The ErrorCode return from QRScanner
public struct RawQRResult {
    let resultString: String
    let errorCode: Int
}

public protocol ReadQRResultService {
    func readQRResultHandler(resultString: String?, errorCode: ReadQRResultCode?) -> ReadQRResult
}

public class ReadQRResultServiceImp: ReadQRResultService {
    init() {}

    struct QRResult: Codable {
        let companyId: String
        let siteId: String
        let clientId: String
        let clientSecret: String
    }

    public func readQRResultHandler(resultString: String?, errorCode: ReadQRResultCode?) -> ReadQRResult {

        guard errorCode != .cancel else {
            return ReadQRResult(resultCode: ReadQRResultCode.cancel, companyId: "", siteId: "", clientId: "", clientSecret: "")
        }

        guard errorCode != .notSupport else {
            return ReadQRResult(resultCode: ReadQRResultCode.notSupport, companyId: "", siteId: "", clientId: "", clientSecret: "")
        }

        guard errorCode != .noQrCode else {
            return ReadQRResult(resultCode: ReadQRResultCode.noQrCode, companyId: "", siteId: "", clientId: "", clientSecret: "")
        }

        guard errorCode != .fail else {
            return ReadQRResult(resultCode: ReadQRResultCode.fail, companyId: "", siteId: "", clientId: "", clientSecret: "")
        }

        do {
            let jsonDecoder = JSONDecoder()

            let result = try jsonDecoder.decode(QRResult.self, from: resultString!.data(using: .utf8)!)

            return ReadQRResult(resultCode: ReadQRResultCode.ok, companyId: result.companyId, siteId: result.siteId, clientId: result.clientId, clientSecret: result.clientSecret)

        } catch {
            print(error)
            return ReadQRResult(resultCode: ReadQRResultCode.fail, companyId: "", siteId: "", clientId: "", clientSecret: "")
        }
    }
}

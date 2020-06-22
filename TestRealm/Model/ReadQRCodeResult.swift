//
//  ReadQRCodeResult.swift
//  TestRealm
//
//  Created by Le.Sang on 2020/06/19.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public enum ReadQRResultCode: CaseIterable {
    case ok
    case fail
    case noQrCode
    case notSupport
    case cancel
}

public class ReadQRResult {
    /// エラーコード
    public let resultCode: ReadQRResultCode
    /// 会社ID
    public let companyId: String
    /// 現場ID
    public let siteId: String
    /// クライアントID
    public let clientId: String
    /// クライアントシークレット
    public let clientSecret: String

    /// QRリーダーの読み込み結果に関する情報を保持するクラスを初期化する
    ///
    /// - Parameters:
    ///   - code: エラーコード
    ///   - companyId: 会社ID
    ///   - siteId: 現場ID
    ///   - clientId: クライアントID
    ///   - clientSecret: クライアントシークレット
    public init(resultCode: ReadQRResultCode, companyId: String, siteId: String, clientId: String, clientSecret: String) {
        self.resultCode = resultCode
        self.companyId = companyId
        self.siteId = siteId
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}

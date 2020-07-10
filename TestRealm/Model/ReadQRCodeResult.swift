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
    ///  コンテンツ
    public let text: String
    /// QRリーダーの読み込み結果に関する情報を保持するクラスを初期化する
    ///
    /// - Parameters:
    ///   - code: エラーコード
    ///   - companyId: 会社ID
    ///   - siteId: 現場ID
    ///   - clientId: クライアントID
    ///   - clientSecret: クライアントシークレット
    public init(resultCode: ReadQRResultCode, text: String) {
        self.resultCode = resultCode
        self.text = text
    }
}

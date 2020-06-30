//
//  ReadQRCode.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/20.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol ReadQRCode {
    ///startReadQRResult
    ///
    /// - Parameters:
    ///   - readQRResult: The Result from ReadQRCodeService

    func startReadQRResult(readQRResult: ReadQRResult)

    func setPresenter(presenter: ReadQRCodePresenter)
}

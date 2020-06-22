//
//  ReadQRCodePresenter.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol ReadQRCodePresenter {
    ///Notify UI the result of QR
    ///
    /// - Parameters:
    ///   - code:ResultCode from QRCode Service
    func notifyQRCodeResult(code: ReadQRResultCode)
}

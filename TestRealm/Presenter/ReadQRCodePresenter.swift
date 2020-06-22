//
//  ReadQRCodePresenter.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol ReadQRCodePresenter {
    //notify UI the result of QR
    func notifyQRCodeResult(code: ReadQRResultCode)

}

//
//  QRScannerViewModel.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/21.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import AVFoundation
import RxRelay

class QRScannerViewModel: BaseViewModel {
    private let readQRCode: ReadQRCode

    init(readQRCode: ReadQRCode) {
        self.readQRCode=readQRCode
    }

    ///startReadQRCode
    ///
    ///- Parameters
    ///  - resultString  : metaOutput valueString
    ///  - errorCode :   ok, fail, noQrCode, notSupport, cancel

    func startReadQRCode(resultString: String?, errorCode: ReadQRResultCode?) {
        readQRCode.setPrestenter(presenter: self)
        readQRCode.startReadQRResult(resultString: resultString, errorCode: errorCode)
    }

}

extension QRScannerViewModel: ReadQRCodePresenter {

    func notifyQRCodeResult(code: ReadQRResultCode) {
        switch code {
        case .ok:
            navigation.accept(QRScannerComplete())
        case .cancel:
            navigation.accept(QRScannerCancel())
        case .fail:
            let failText = "Not a validate QR code"
            navigation.accept(ShowMessage(message: failText))
        case .noQrCode:
            let failText = "No QR code is detected"
            navigation.accept(ShowMessage(message: failText))
        case .notSupport:
            let failText = "Failed to get the camera device"
            navigation.accept(ShowMessage(message: failText))
        }
    }

}

extension QRScannerViewModel {
    class ShowMessage: ViewModelEvent {
        let message: String

        init(message: String) {
            self.message = message
        }
    }

    class QRScannerComplete: ViewModelEvent {}

    class QRScannerCancel: ViewModelEvent {}

}

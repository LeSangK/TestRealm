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

    ///Start Read QRCode Result from metaOutput
    ///
    ///- Parameters:
    ///  - resultString :metaOutput valueString
    ///  - errorCode : ok, fail, noQrCode, notSupport, cancel
    func saveQrResult(resultString: String?, errorCode: ReadQRResultCode?) {
        QRResultHandler(resultString: resultString, errorCode: errorCode) { result in
            readQRCode.setPresenter(presenter: self)
            readQRCode.startReadQRResult(readQRResult: result)
        }
    }

    private func QRResultHandler(resultString: String?, errorCode: ReadQRResultCode?, completionHandler: (ReadQRResult) -> Void) {

        guard errorCode != .cancel else {
            completionHandler(ReadQRResult(resultCode: .cancel, text: ""))
            return
        }

        guard errorCode != .notSupport else {
            completionHandler(ReadQRResult(resultCode: .notSupport, text: ""))
            return
        }

        guard errorCode != .noQrCode else {
            completionHandler(ReadQRResult(resultCode: .noQrCode, text: ""))
            return
        }

        guard let s = resultString else {
            completionHandler(ReadQRResult(resultCode: .fail, text: ""))
            return
        }

        completionHandler(ReadQRResult(resultCode: .ok, text: s))
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

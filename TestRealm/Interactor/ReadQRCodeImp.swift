//
//  ReadQRCodeImp.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public class ReadQRCodeImp: ReadQRCode {
    private let repository: ReadQRCodeRepository
    private let service: ReadQRResultService
    private var presenter: ReadQRCodePresenter?

    init(repository: ReadQRCodeRepository, service: ReadQRResultService) {
        self.repository=repository
        self.service=service
    }

    public func startReadQRResult(resultString: String?, errorCode: ReadQRResultCode?) {
        let result = service.readQRResultHandler(resultString: resultString, errorCode: errorCode)

        repository.addNewTodo(result: result)

        presenter?.notifyQRCodeResult(code: result.resultCode)
    }

    public func setPresenter(presenter: ReadQRCodePresenter) {
        self.presenter=presenter
    }

}

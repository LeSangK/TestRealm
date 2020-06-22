//
//  ReadQRCodeImp.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public class ReadQRCodeImp: ReadQRCode {
    private let repository: RealmRepository
    private let service: ReadQRResultService
    private var presenter: ReadQRCodePresenter?

    init(repository: RealmRepository, service: ReadQRResultService) {
        self.repository=repository
        self.service=service
    }

    public func startReadQRResult(resultString: String?, errorCode: ReadQRResultCode?) {
        let result = service.readQRResultHandler(resultString: resultString, errorCode: errorCode)

        if result.resultCode == .ok {
            repository.addNewTodo(str: "companyId\(result.companyId), siteId:\(result.siteId), clinetId\(result.clientId)")
        }

        presenter?.notifyQRCodeResult(code: result.resultCode)
    }

    public func setPrestenter(presenter: ReadQRCodePresenter) {
        self.presenter=presenter
    }

}

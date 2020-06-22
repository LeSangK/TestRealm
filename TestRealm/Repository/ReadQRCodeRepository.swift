//
//  ReadQRCodeRepository.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol ReadQRCodeRepository {
    //add QRCode result to realm
    func addNewTodo(result: ReadQRResult)
}

public class ReadQRCodeRepositoryImp: ReadQRCodeRepository {
    private let todoDataStore: TodoDataStore

    init() {
        self.todoDataStore=TodoDataStoreImp()
    }

    public func addNewTodo(result: ReadQRResult) {
        if result.resultCode == .ok {
            let todo = TodoModel()
            todo.text="companyId\(result.companyId), siteId:\(result.siteId), clinetId\(result.clientId)"
            todoDataStore.addNewTodo(todo: todo)
        }
    }
}

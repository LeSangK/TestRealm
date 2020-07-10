//
//  ReadQRCodeRepository.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol ReadQRCodeRepository {
    ///Add QRCode result to realm
    ///
    /// - Parameters:
    ///   - result : The result from QRCode Service
    func addNewTodo(result: ReadQRResult)
}

class ReadQRCodeRepositoryImp: ReadQRCodeRepository {
    private let todoDataStore: TodoDataStore

    init(todoDataStore: TodoDataStore) {
        self.todoDataStore=todoDataStore
    }

    func addNewTodo(result: ReadQRResult) {
        if result.resultCode == .ok {
            let todo = TodoModel()
            todo.text=result.text
            todoDataStore.addNewTodo(todo: todo)
        }
    }
}

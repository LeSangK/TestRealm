//
//  TodoDataStoreTest.swift
//  TestRealmTests
//
//  Created by 楽桑 on 2020/07/05.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RealmSwift
@testable import TestRealm

// swiftlint:disable force_try
class TodoDataStoreTest: XCTestCase {
    override func setUp() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func testFetchNull() {
        let dataStore  = TodoDataStoreImp()
        let todos=dataStore.fetchTodo()
        XCTAssertEqual(todos?.count, 0)
    }

    func testSaveSuccess() {
        let testString = "test"
        let dataStore  = TodoDataStoreImp()
        let todo =  TodoModel()
        todo.text=testString
        dataStore.addNewTodo(todo: todo)
        let todos=dataStore.fetchTodo()

        XCTAssertEqual(todos![0].text, "test")
    }

    func testClear() {
        let testString = "test"
        let dataStore  = TodoDataStoreImp()
        let todo =  TodoModel()
        todo.text=testString
        dataStore.addNewTodo(todo: todo)
        dataStore.clear()
        let todos=dataStore.fetchTodo()

        XCTAssertEqual(todos?.count, 0)
    }

    func testDelete() {
        let testString = "test"
        let testString2 = "test2"
        let dataStore  = TodoDataStoreImp()
        let todo =  TodoModel()
        let todo2 = TodoModel()
        todo.text=testString
        todo2.text=testString2
        dataStore.addNewTodo(todo: todo)
        dataStore.addNewTodo(todo: todo2)
        dataStore.deleteTodo(todo: todo)
        let todos=dataStore.fetchTodo()

        XCTAssertEqual(todos![0].text, "test2")
    }
}

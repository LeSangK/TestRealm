//
//  ReadQRCodeRepositoryTest.swift
//  TestRealmTests
//
//  Created by 楽桑 on 2020/07/04.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo

@testable import TestRealm

class ReadQRCodeRepositoryTest: XCTestCase {

    func testSaveSuccess() {
        let expectedResult = TodoModel()
        expectedResult.text="hello QR"

        let result = ReadQRResult(resultCode: .ok, text: "hello QR")

        let mockTodoDataStore = MockTodoDataStore()
        stub(mockTodoDataStore) { mock in
            when(mock.addNewTodo(todo: any())).then {todo in
                XCTAssertEqual(todo.text, expectedResult.text)
            }
        }

        let target = ReadQRCodeRepositoryImp(todoDataStore: mockTodoDataStore)
        target.addNewTodo(result: result)

    }
}

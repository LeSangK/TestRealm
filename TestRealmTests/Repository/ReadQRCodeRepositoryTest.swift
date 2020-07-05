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
        expectedResult.text="companyId:2, siteId:3, clinetId:4"

        let result = ReadQRResult(resultCode: .ok, companyId: "2", siteId: "3", clientId: "4", clientSecret: "5")

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

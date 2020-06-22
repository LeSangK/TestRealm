//
//  TodoActionPresenter.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol TodoActionPresenter {
    ///notify UI FetchTodos  Completed
    func notifyFetchTodos(results: [String])

    ///notify UI to reload tabelView
    func notfyReloadTable()

    ///notify UI to reset textField
    func notifyResetTextField()
}

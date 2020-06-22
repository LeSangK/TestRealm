//
//  TodoActionPresenter.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol TodoActionPresenter {
    ///Notify UI FetchTodos  Completed
    ///
    ///- Parameters:
    ///  - results: Fetching  from database
    func notifyFetchTodos(results: [String])

    ///Notify UI to reload tabelView
    func notfyReloadTable()

    ///Notify UI to reset textField
    func notifyResetTextField()
}

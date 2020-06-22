//
//  TodoAction.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol TodoAction {
    //fetchTodos
    func fetchTodos()

    //addNewTodo
    func addNewTodo(str: String?)

    //deleteTodo
    func deleteTodo(index: Int)

    //clear
    func deleteAll()

    //set Presenter
    func setPresenter(presenter: TodoActionPresenter)
}

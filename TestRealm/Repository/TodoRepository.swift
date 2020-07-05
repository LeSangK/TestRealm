//
//  TodoRepository.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol TodoRepository {
    ///fetch Todos from database
    ///
    /// - Returns: String Array
    func fetchTodos() -> [String]!

    ///Add  NewTodo to database
    ///
    /// - Parameters:
    ///   - str: string  will add to Database
    func addNewTodo(str: String?)

    ///DeleteTodo from database
    ///
    ///- Parameters:
    ///   - index : index of table rows
    func deleteTodo(index: Int)

    ///Clear all of data of database
    func deleteAll()
}

class TodoRepositoryImp: TodoRepository {
    private let todoDataStore: TodoDataStore

    init(todoDataStore: TodoDataStore) {
        self.todoDataStore = todoDataStore
    }

    func fetchTodos() -> [String]! {
        guard let results = todoDataStore.fetchTodo() else {
            return []
        }

        var array = [String]()
        for index in 0 ..< results.count {
            if let result = results[index].text {
                array.append(result)
            }
        }
        return array
    }

    func addNewTodo(str: String?) {
        let todo = TodoModel()
        todo.text = str
        todoDataStore.addNewTodo(todo: todo)
    }

    func deleteTodo(index: Int) {
        let results = todoDataStore.fetchTodo()
        let todo = results![index]
        todoDataStore.deleteTodo(todo: todo)
    }

    func deleteAll() {
        todoDataStore.clear()
    }

}

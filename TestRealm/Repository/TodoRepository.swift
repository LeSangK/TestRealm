//
//  TodoRepository.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public protocol TodoRepository {
    //fetchTodos
    func fetchTodos() -> [String]!

    //addNewTodo
    func addNewTodo(str: String?)

    //deleteTodo
    func deleteTodo(index: Int)

    //clear
    func deleteAll()
}

public class TodoRepositoryImp: TodoRepository {
    private let todoDataStore: TodoDataStore

    init() {
        self.todoDataStore = TodoDataStoreImp()
    }

    public func fetchTodos() -> [String]! {
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

    public func addNewTodo(str: String?) {
        let todo = TodoModel()
        todo.text = str
        todoDataStore.addNewTodo(todo: todo)
    }

    public func deleteTodo(index: Int) {
        let results = todoDataStore.fetchTodo()
        let todo = results![index]
        todoDataStore.deleteTodo(todo: todo)
    }

    public func deleteAll() {
        todoDataStore.clear()
    }

}

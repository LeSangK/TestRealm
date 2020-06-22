//
//  TodoActionImp.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

public class TodoActionImp: TodoAction {
    private let repository: TodoRepository
    private var presenter: TodoActionPresenter?

    init(repository: TodoRepository) {
        self.repository=repository
    }

    public func fetchTodos() {
        let todos = repository.fetchTodos()
        presenter?.notifyFetchTodos(results: todos!)
    }

    public func addNewTodo(str: String?) {
        repository.addNewTodo(str: str)
        presenter?.notifyResetTextField()
        presenter?.notfyReloadTable()
    }

    public func deleteTodo(index: Int) {
        repository.deleteTodo(index: index)
        presenter?.notfyReloadTable()
    }

    public func deleteAll() {
        repository.deleteAll()
        presenter?.notfyReloadTable()
    }

    public func setPresenter(presenter: TodoActionPresenter) {
        self.presenter = presenter
    }

}

//
//  TodoViewModel.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/22.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation

enum TodoActionType: CaseIterable {
    case fetch
    case add
    case delete
    case clear
}

class TodoViewModel: BaseViewModel {
    private let todoAction: TodoAction

    init(todoAction: TodoAction) {
        self.todoAction = todoAction
    }

    func handleTodoAction(action: TodoActionType, parameter: Any?) {
        todoAction.setPresenter(presenter: self)
        switch action {
        case .add:
            // swiftlint:disable:next force_cast
            todoAction.addNewTodo(str: (parameter as! String))
        case .fetch:
            todoAction.fetchTodos()
        case .delete:
            // swiftlint:disable:next force_cast
            todoAction.deleteTodo(index: (parameter as! Int))
        case .clear:
            todoAction.deleteAll()
        }
    }

}

extension TodoViewModel: TodoActionPresenter {
    func notifyReloadTable() {
        self.navigation.accept(ReloadTable())
    }

    func notifyResetTextField() {
        self.navigation.accept(ResetTextField())
    }

    func notifyFetchTodos(results: [String]) {
        self.navigation.accept(FetchTodosSuccess(todos: results))
    }

}

extension TodoViewModel {
    class FetchTodosSuccess: ViewModelEvent {
        let todos: [String]
        init(todos: [String]) {
            self.todos = todos
        }
    }

    class ReloadTable: ViewModelEvent {}

    class ResetTextField: ViewModelEvent {}
}

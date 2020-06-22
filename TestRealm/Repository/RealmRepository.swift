//
//  RealmRepository.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/07.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import RealmSwift

public protocol RealmRepository {
    func fetchTodo()->Results<TodoModel>!
    func addNewTodo(str: String)
    func deleteTodo(todo: TodoModel)
    func clear()
}

public class RealmRepositoryImp: RealmRepository {
    let realm: Realm

    init() {
        // swiftlint:disable:next force_try
        realm = try! Realm()
    }

    public func fetchTodo() -> Results<TodoModel>! {

        return self.realm.objects(TodoModel.self)
    }

    public func addNewTodo(str: String) {
        let todo: TodoModel = TodoModel()
        todo.text=str
        // swiftlint:disable:next force_try
        try! realm.write {
            self.realm.add(todo)
        }
    }

    public func clear() {
        // swiftlint:disable:next force_try
        try! realm.write {
            self.realm.deleteAll()
        }
    }

    public func deleteTodo(todo: TodoModel) {
        // swiftlint:disable:next force_try
        try! realm.write {
            self.realm.delete(todo)
        }
    }
}

//
//  TodoDataStore.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/07.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import RealmSwift

public protocol TodoDataStore {
    func fetchTodo()->Results<TodoModel>?
    func addNewTodo(todo: TodoModel)
    func deleteTodo(todo: TodoModel)
    func clear()
}

public class TodoDataStoreImp: TodoDataStore {
    init() {}

    public func fetchTodo() -> Results<TodoModel>? {
        do {
            let realm = try Realm()
            return realm.objects(TodoModel.self)
        } catch {
            print(error)
            return nil
        }

    }

    public func addNewTodo(todo: TodoModel) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(todo)
            }
        } catch {
            print(error)
        }
    }

    public func clear() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }

    public func deleteTodo(todo: TodoModel) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print(error)
        }
    }
}

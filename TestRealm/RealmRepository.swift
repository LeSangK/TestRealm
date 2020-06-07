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
    func addNewTodo(todo:TodoModel) ->Void
    func deleteTodo(todo:TodoModel) ->Void
    func clear() 
}

public class RealmRepositoryImp : RealmRepository{
    let realm : Realm
    
    init(){
        realm = try! Realm()
    }
    
    public func fetchTodo() -> Results<TodoModel>! {
        
        return self.realm.objects(TodoModel.self)
    }
    
    public func addNewTodo(todo:TodoModel) {
        try! realm.write{
            self.realm.add(todo)
        }
    }
    
    public func clear(){
        try! realm.write{
            self.realm.deleteAll()
        }
    }
    
    public func deleteTodo(todo: TodoModel) {
        try! realm.write{
            self.realm.delete(todo)
        }
    }
}


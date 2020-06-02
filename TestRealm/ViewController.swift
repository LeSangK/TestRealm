//
//  ViewController.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/05/30.
//  Copyright © 2020 楽桑. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController ,UITextFieldDelegate{
    
    //テキストフィールドとテーブルビューを紐付け
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var table: UITableView!
    
    var itemList : Results<TodoModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        
        
        self.itemList=realm.objects(TodoModel.self)
    }
    
    @IBAction func addTodo(){
        let todo :TodoModel = TodoModel()
        
        todo.text=self.textField.text
        
        let  realm = try! Realm()
        
        try! realm.write{
            realm.add(todo)
        }
        
        self.textField.text=""
        self.table.reloadData()
    }
    
    @IBAction func deleteAll(){
        let  realm = try! Realm()
            
            try! realm.write{
                realm.deleteAll()
            }
    }
    
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath)
        
        let item:TodoModel = self.itemList[indexPath.row]
        cell.textLabel?.text=item.text
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item:TodoModel = self.itemList[indexPath.row]
        let  realm = try! Realm()
        
        try! realm.write{
            realm.delete(item.self)
        }
        
        self.table.reloadData()

    }
}

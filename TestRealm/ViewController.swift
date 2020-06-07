//
//  ViewController.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/05/30.
//  Copyright © 2020 楽桑. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let realmRepository = RealmRepositoryImp()
    
    var itemList : Results<TodoModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.itemList=realmRepository.fetchTodo()
        
        addButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                let todo :TodoModel = TodoModel()
                todo.text=self?.textField.text
                self?.realmRepository.addNewTodo(todo: todo)
                self?.textField.text=""
                self?.table.reloadData()
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: {[weak self]_ in
                self?.realmRepository.clear()
                self?.table.reloadData()
            })
            .disposed(by: disposeBag)
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
        self.realmRepository.deleteTodo(todo:item.self)
        self.table.reloadData()
        
    }
}

//
//  TodoViewController.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/05/30.
//  Copyright © 2020 楽桑. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class TodoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!

    private let disposeBag = DisposeBag()
    private let todoRepository = TodoRepositoryImp()

    public var todoAction: TodoAction?
    var viewModel: TodoViewModel?

    var itemList: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoAction = TodoActionImp(repository: todoRepository)
        viewModel = TodoViewModel(todoAction: todoAction!)

        viewModel?.navigation
            .observeOn(MainScheduler.init())
            .subscribe(onNext: { [weak self] event in
                switch event {
                case let event  as TodoViewModel.FetchTodosSuccess:
                    self?.initalizeTable(event: event)
                case _ as TodoViewModel.ReloadTable:
                    self?.viewModel?.handleTodoAction(action: .fetch, parameter: nil)
                case _ as TodoViewModel.ResetTextField:
                    self?.textField.text = ""
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        addButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let text = self?.textField.text else {
                    return
                }
                self?.viewModel?.handleTodoAction(action: .add, parameter: text)
            })
            .disposed(by: disposeBag)

        deleteButton.rx.tap
            .subscribe(onNext: {[weak self]_ in
                self?.viewModel?.handleTodoAction(action: .clear, parameter: nil)
            })
            .disposed(by: disposeBag)

        scanButton.rx.tap
            .subscribe(onNext: {[weak self]_ in
                let QRScanner = self?.storyboard?.instantiateViewController(withIdentifier: "QRScannerController")
                QRScanner?.modalPresentationStyle = .fullScreen
                //ここが実際に移動するコードとなります
                self?.present(QRScanner!, animated: true, completion: nil)            })
            .disposed(by: disposeBag)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.handleTodoAction(action: .fetch, parameter: nil)
    }

    func initalizeTable(event: TodoViewModel.FetchTodosSuccess) {
        self.itemList = event.todos
        table.reloadData()
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.itemList != nil else {
            return 0
        }
        return self.itemList!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath)

        cell.textLabel?.text=self.itemList![indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        self.viewModel?.handleTodoAction(action: .delete, parameter: indexPath.row)
        self.table.reloadData()
    }
}

//
//  TodoModel.swift
//  TestRealm
//
//  Created by 楽桑 on 2020/06/02.
//  Copyright © 2020 楽桑. All rights reserved.
//

import Foundation
import RealmSwift

public class TodoModel: Object {
    @objc dynamic var text: String?
}

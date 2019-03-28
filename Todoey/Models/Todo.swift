//
//  Todo.swift
//  Todoey
//
//  Created by Megan Sharon on 3/27/19.
//  Copyright © 2019 Megan Sharon. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var createdOn: Date?
    let category = LinkingObjects(fromType: Category.self, property: "todos")
}

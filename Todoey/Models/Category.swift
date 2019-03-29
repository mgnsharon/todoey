//
//  Category.swift
//  Todoey
//
//  Created by Megan Sharon on 3/27/19.
//  Copyright © 2019 Megan Sharon. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var createdOn: Date?
    @objc dynamic var color = ""
    let todos = List<Todo>()
}

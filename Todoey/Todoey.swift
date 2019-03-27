//
//  Todoey.swift
//  Todoey
//
//  Created by Megan Sharon on 3/26/19.
//  Copyright © 2019 Megan Sharon. All rights reserved.
//

import Foundation

class Todoey: CustomStringConvertible, Codable {
    
    var isComplete = false
    var title = ""
    
    var description: String {
        return "Todoey: \(title) Complete: \(isComplete)"
    }

}

//
//  ViewController.swift
//  Todoey
//
//  Created by Megan Sharon on 3/26/19.
//  Copyright © 2019 Megan Sharon. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items: [Todoey] = []
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("Todoeys.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodoeys()
    }

    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isComplete ? .checkmark : .none

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isComplete = !item.isComplete
        save()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let newItem = textField.text {
                if !newItem.isEmpty {
                    let todo = Todoey()
                    todo.title = newItem
                    self.add(todoey: todo)
                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create New Todoey"
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func add(todoey: Todoey) {
        
        items.append(todoey)
        save()
        
    }
    
    func save() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadTodoeys() {
        
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            items = try decoder.decode([Todoey].self, from: data)
        } catch {
            print(error)
        }
    }
    
}


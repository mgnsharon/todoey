//
//  ViewController.swift
//  Todoey
//
//  Created by Megan Sharon on 3/26/19.
//  Copyright © 2019 Megan Sharon. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController, UISearchBarDelegate {

    let realm = try! Realm()
    var items: Results<Todo>?
    var selectedCategory: Category? {
        didSet {
            loadTodos()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let category = selectedCategory else {return}
        title = category.name
        updateNavBar(withHexCode: category.color)
        searchBar.barTintColor = UIColor(hexString: category.color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "#34495e")
    }

    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row],
            let total = items?.count {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            let hexValue = item.category.first?.color ?? UIColor.flatGray.hexValue()
            if let color = UIColor(hexString: hexValue) {
                let darkify = CGFloat(indexPath.row) / CGFloat(total)
                let darkColor = color.darken(byPercentage: darkify)
                let contrastColor = ContrastColorOf(darkColor!, returnFlat: true)
                cell.backgroundColor = darkColor
                cell.textLabel?.textColor = contrastColor
                cell.tintColor = contrastColor
            }
            
            
        } else {
            cell.textLabel?.text = "No Todos Added..."
        }

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            try! realm.write {
                item.done = !item.done
            }
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let title = textField.text else { return }
            if !title.isEmpty {
                if let category = self.selectedCategory {
                    try! self.realm.write {
                        let todo = Todo()
                        todo.title = title
                        todo.createdOn = Date()
                        category.todos.append(todo)
                    }
                    self.tableView.reloadData()
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
    
    func loadTodos() {

        items = selectedCategory?.todos.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.count > 0 {
            items = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "createdOn", ascending: true)
            tableView.reloadData()
        } else {
            loadTodos()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTodos()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        guard let item = self.items?[indexPath.row] else { return }
        
        do {
            try self.realm.write {
                self.realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
}


//
//  ViewController.swift
//  Todoey
//
//  Created by Dani Raine on 6/12/19.
//  Copyright © 2019 iNerdGirl LLC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var toDoItemArray = [ToDoItem]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newToDoItem = ToDoItem()
        newToDoItem.title = "Learn Swift"
        toDoItemArray.append(newToDoItem)
        
        let newToDoItem2 = ToDoItem()
        newToDoItem2.title = "Learn SwiftUI"
        toDoItemArray.append(newToDoItem2)
        
        let newToDoItem3 = ToDoItem()
        newToDoItem3.title = "Become App Developer"
        toDoItemArray.append(newToDoItem3)
        if let items = defaults.array(forKey: "ToDoListArray") as? [ToDoItem] {
            toDoItemArray = items
        }
    }

    // MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoItemArray[indexPath.row].title
        
        cell.accessoryType = toDoItemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    // MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoItemArray[indexPath.row].done = !toDoItemArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            let newToDoItem = ToDoItem()
            newToDoItem.title = textField.text!
            self.defaults.set(self.toDoItemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

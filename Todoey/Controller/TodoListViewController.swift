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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
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
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
        let deleteAction = UITableViewRowAction(style: .destructive, title: deleteTitle) { (action, indexPath) in
            self.toDoItemArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return [deleteAction]
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newToDoItem = ToDoItem()
            newToDoItem.title = textField.text!
            self.toDoItemArray.append(newToDoItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Model Manupulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.toDoItemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                toDoItemArray = try decoder.decode([ToDoItem].self, from: data)
            } catch {
                print("Error decoding item aray, \(error)")
            }
        }
    }
    
}

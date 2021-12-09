//
//  ViewController.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 09.12.2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let userDefaults = UserDefaults()
    var itemArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeArray = (userDefaults.array(forKey: "ItemArray") as? [String]) {
            itemArray = safeArray
        }
    }
    
    //MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType =
        (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark)
        ? .none
        : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            if !textField.text!.isEmpty{
                self.itemArray.append(textField.text!)
                self.userDefaults.set(self.itemArray, forKey: "ItemArray")
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 09.12.2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedCategory: Category? {
        didSet {
            items = CRUD.query(Item.self)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = getAccessoryMark(from: items[indexPath.row].changeDone())
        tableView.deselectRow(at: indexPath, animated: true)
        releaseSearchBar()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            if !textField.text!.isEmpty{
                let newItem = CRUD.create(Item.self)
                newItem.title = textField.text!
                newItem.parentCategory = self.selectedCategory
                self.items.append(newItem)
                CRUD.saveChanges()
            }
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { field in
            field.placeholder = "Create new item"
            textField = field
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func getAccessoryMark(from isDone: Bool) -> UITableViewCell.AccessoryType {
        return isDone
            ? .checkmark
            : .none
    }
}

//MARK: - TableView Datasource
extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = getAccessoryMark(from: item.done)
        
        return cell
    }
}

//MARK: - Search bar
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        items = CRUD.search(Item.self, by: searchBar.text!, in: selectedCategory)
        
        if searchBar.text!.isEmpty {
            releaseSearchBar()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        releaseSearchBar()
    }
    
    func releaseSearchBar() {
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
    }
}

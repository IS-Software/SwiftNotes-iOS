//
//  ViewController.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 09.12.2021.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
           loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = getAccessoryMark(from: RealmCRUD.toggleItem(items?[indexPath.row]))
        tableView.deselectRow(at: indexPath, animated: true)
        releaseSearchBar()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            if !textField.text!.isEmpty{
                if let currentCategory = self.selectedCategory {
                    if RealmCRUD.addItem(title: textField.text!, category: currentCategory) {
                        self.tableView.reloadData()
                    }
                }
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
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = items?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "No items"
        cell.accessoryType = getAccessoryMark(from: item?.done ?? false)
        
        return cell
    }
}

//MARK: - Search bar
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       items = RealmCRUD.search(searchBar.text!, in: &items)
        
        if searchBar.text!.isEmpty {
            loadItems()
            releaseSearchBar()
        } else {
            tableView.reloadData()
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
    
    func loadItems() {
        items = selectedCategory!.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - SwipeCells
extension TodoListViewController: SwipeTableViewCellDelegate {
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                if RealmCRUD.destroy(self.items?[indexPath.row]) {
                    tableView.reloadData()
                }
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")

            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

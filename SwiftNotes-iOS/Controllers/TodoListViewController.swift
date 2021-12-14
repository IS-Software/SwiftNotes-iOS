//
//  ViewController.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 09.12.2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var items: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    var categoryColor = UIColor.white
    
    func loadItems() {
        items = selectedCategory!.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = selectedCategory?.title ?? "Items"        
        if let colorHex = selectedCategory?.color {
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist") }
            
            categoryColor = UIColor(hexString: colorHex).lighten(byPercentage: 100.0 / CGFloat(items!.count)) ?? UIColor.blue
            let contrastColor = ContrastColorOf(backgroundColor: categoryColor, returnFlat: true)
            navBar.barTintColor = categoryColor.lighten(byPercentage: 100.0 / CGFloat(items!.count)) ?? UIColor.blue
            navBar.tintColor = contrastColor
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
            searchBar.barTintColor = categoryColor
        }

    }
    
    //MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            let currentColor = categoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) ?? UIColor.white
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: currentColor, returnFlat: true)
            cell.accessoryType = getAccessoryMark(from: item.done)
            cell.backgroundColor = currentColor
        }
            
        return cell
    }
    
    //MARK: - Cells actions
    override func swipeDo(at indexPath: IndexPath) {
        _ = RealmCRUD.destroy(self.items?[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = getAccessoryMark(from: RealmCRUD.toggleItem(items?[indexPath.row]))
        tableView.deselectRow(at: indexPath, animated: true)
        releaseSearchBar()
    }
    
    //MARK: - UI
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
}

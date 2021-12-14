//
//  CategoryViewController.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 12.12.2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var categories: Results<Category>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        categories = RealmCRUD.query(Category.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist") }
        
        navBar.barTintColor = UIColor.gray
        navBar.tintColor = UIColor.white
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK: - Table datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            let currentColor = UIColor(hexString: category.color) ?? UIColor.white
            cell.textLabel?.text = category.title
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: currentColor, returnFlat: true)
            cell.backgroundColor = currentColor
        }
        
        return cell
    }
    
    //MARK: - Cells actions
    override func swipeDo(at indexPath: IndexPath) {
        _ = RealmCRUD.destroy(categories?[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - UI
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if !textField.text!.isEmpty{
                if RealmCRUD.addCategory(title: textField.text!, hex: UIColor.randomFlat().hexValue()) {
                    self.tableView.reloadData()
                }
            }
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { field in
            field.placeholder = "New category name"
            textField = field
        }
        
        present(alert, animated: true)
    }
}

//
//  CategoryViewController.swift
//  SwiftNotes-iOS
//
//  Created by idStorm on 12.12.2021.
//

import UIKit

class CategoryViewController: UITableViewController {

    var categories = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = CRUD.query(Category.self)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if !textField.text!.isEmpty{
                let newCategory = CRUD.create(Category.self)
                newCategory.title = textField.text!
                self.categories.append(newCategory)
                CRUD.saveChanges()
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
    
    //MARK: - Select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories[indexPath.row]
        }
    }
}

//MARK: - Table datasource
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }
}

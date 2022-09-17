//
//  CategoryVC.swift
//  TodoList-Realm
//
//  Created by Khater on 9/15/22.
//

import UIKit
import RealmSwift

class CategoryVC: SwipeTableViewController {
    
    let realm = try? Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        categories = realm?.objects(Category.self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "New Category", message: "Add name of Category", preferredStyle: .alert)
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Category name..."
                textField = alertTextField
            }
            
            let addButton = UIAlertAction(title: "Add", style: .default){ _ in
                if let text = textField.text, text != ""{
                    
                    let newCategory = Category()
                    newCategory.name = text
                    
                    self.saveCategory(category: newCategory)
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: .none)
            
            
            alert.addAction(addButton)
            alert.addAction(cancelButton)
        
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Delete Category
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row]{
            try? realm?.write({
                realm?.delete(category)
            })
        }
    }
}


// MARK: - TableView DataSource
extension CategoryVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name
        
        return cell
    }
}



// MARK: - TableView Delegate
extension CategoryVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.todoVCIdentifier, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let todoListVC = segue.destination as? TodoListVC else { return }
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            print(indexPath.row)
            todoListVC.selectedCategory = categories?[indexPath.row]
        }
    }
}


// MARK: - Data Minapulation
extension CategoryVC{
    func saveCategory(category: Category){
        guard let realm = realm else {
            print("Real is nil")
            return }
        do {
            try realm.write {
                
                realm.add(category)
            }
            
            self.tableView.reloadData()
        } catch{
            print("Error Saving Category!  \(error)")
        }
    }
    
    
}



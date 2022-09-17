//
//  ViewController.swift
//  TodoList-Realm
//
//  Created by Khater on 9/15/22.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TodoListVC: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try? Realm()
    
    var selectedCategory: Category? {
        didSet{
            // Read from Realm
            if let selectedCategory = selectedCategory {
                items = selectedCategory.items.sorted(byKeyPath: "title", ascending: true)
            }
        }
    }
    
    var items: Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        guard let selectedCategory = selectedCategory else { return }

        DispatchQueue.main.async {
            var textField = UITextField()
            
            let alert = UIAlertController(title: "New Category", message: "Add name of Category", preferredStyle: .alert)
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Category name..."
                textField = alertTextField
            }
            
            let addButton = UIAlertAction(title: "Add", style: .default){ _ in
                
                if let text = textField.text, text != ""{
                    do {
                        try self.realm?.write {
                            let newItem = Item()
                            newItem.title = text
                            newItem.checked = false
                            newItem.dateCreated = Date.now
                            selectedCategory.items.append(newItem)
                        }
                        
                        self.tableView.reloadData()
                    } catch let error as NSError {
                        print("Error Saving Category!  \(error)")
                    }
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: .none)
            
            
            alert.addAction(addButton)
            alert.addAction(cancelButton)
        
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Delete item
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            try? realm?.write({
                realm?.delete(item)
            })
        }
    }
}


// MARK: - TableView DataSource
extension TodoListVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType  = item.checked ? .checkmark : .none
        }
        
        
        return cell
    }
}

// MARK: - TableView Delegate
extension TodoListVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            try? realm?.write({
                item.checked = !item.checked
            })
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
}


// MARK: - Search Bar
extension TodoListVC: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        items = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
        //items = items?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchText)).sorted(byKeyPath: "title", ascending: true)
        
        
        
        
        if searchText.count == 0 || items?.count == 0{
            if let selectedCategory = selectedCategory {
                items = selectedCategory.items.sorted(byKeyPath: "title", ascending: true)
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        if let selectedCategory = selectedCategory {
            items = selectedCategory.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
    }
}


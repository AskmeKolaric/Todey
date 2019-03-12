//
//  TodoTableViewController.swift
//  Todey
//
//  Created by Marko Kolaric on 08.03.19.
//  Copyright © 2019 Marko Kolaric. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Items>?
    
    var selectedCategory : Categories? {
        didSet{
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:
                //                currentli on row #5
                //theres a total of 10 items in todoItmes
                (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
//            print("Version 1 : \(CGFloat(indexPath.row / todoItems!.count)))")
//            print("Version 2 : \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
            //Tenary operator ==>
            // value = codition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
                cell.textLabel?.text = "No Items added yet"
        }
        return cell
    }
    
    // MARK: Tabel view Delegate Methodes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let items = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    items.done = !items.done
                }
            } catch {
              print("Error saving done status,\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //    MARK: - Delete Methods
    override func updatedModel(at indexPath: IndexPath) {
        
        if let itemsForDeletions = todoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemsForDeletions)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    // MARK: - Add new Items section
    
    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textFiledItem = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will hapedn when user click on barbutton

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItems = Items()
                        newItems.title = textFiledItem.text!
                        newItems.dateCreated =  Date()
                        currentCategory.items.append(newItems)
                    }
                } catch {
                    print("Error saveing new items. \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new Item"
            textFiledItem = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manupulati Methods
    
   func loadItems() {
    
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
        tableView.reloadData()
    }
}

    //    MARK: - Search Bar Methiods

extension TodoTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
            tableView.reloadData()
     }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
                loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by Marko Kolaric on 10.03.19.
//  Copyright © 2019 Marko Kolaric. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var category: Results<Categories>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
       
        
    }
    
    //    MARK: - TableView Datasource Methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
//        nil Coalescing Operator
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        cell.textLabel?.text = category?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = UIColor(hexString: category?[indexPath.row].colour ?? "0096FF" )
        
        return cell
    }
    
    //    MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoTableViewController
        
        
        if  let indextPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = category?[indextPath.row]
        }
    }
    
    //    MARK: - Data Maniputaion Methodos
    
    func save(category: Categories) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saveing context \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategories() {

        category = realm.objects(Categories.self)

        tableView.reloadData()
    }
    //    MARK: - Delete Datefrom Swipe
    
    override func updatedModel(at indexPath: IndexPath) {
        
             if let categoryForDeletions = category?[indexPath.row] {
               do{
                    try self.realm.write {
                    self.realm.delete(categoryForDeletions)
                    }
               } catch {
                    print("Error deleting category, \(error)")
            }
        }
    }
    
    //    MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            
            let newCategory = Categories()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Add New Category"
            textField = categoryTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}


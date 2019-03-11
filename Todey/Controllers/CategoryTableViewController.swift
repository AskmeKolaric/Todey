//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by Marko Kolaric on 10.03.19.
//  Copyright © 2019 Marko Kolaric. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var category = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }
    
    //    MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row].name
        
        return cell
    }
    
    //    MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoTableViewController
        
        
        if  let indextPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indextPath.row]
        }
    }
    
    //    MARK: - Data Maniputaion Methodos
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saveing context \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
           category = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    //    MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.category.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Add New Category"
            textField = categoryTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

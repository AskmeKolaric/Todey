//
//  TodoTableViewController.swift
//  Todey
//
//  Created by Marko Kolaric on 08.03.19.
//  Copyright © 2019 Marko Kolaric. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = Item()
        newItem.title = "Hawaii"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Life"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Style"
        itemArray.append(newItem3)
        
         if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
           itemArray = items
        }
    }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        //Tenary operator ==>
        // value = codition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK: Tabel view Delegate Methodes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.tableView.reloadData() 
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    // MARK: - Add new Items section
    
    @IBAction func addButtonPresed(_ sender: UIBarButtonItem) {
        
        var textFiledItem = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will hapedn when user click on barbutton
            
            let newItems = Item()
            newItems.title = textFiledItem.text!
            self.itemArray.append(newItems)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData() 
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new Item"
            textFiledItem = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

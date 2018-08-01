//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Pedro Carmezim on 01/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var itemArray = ["Find Mike","Find Holand"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the array so appear as a defaultUser BindingOptional, dont crash the app
        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
    }

    
    //MARK: - Tableview DS Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    //-------------
    
    //MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    //MARK: - Addnew Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Wat happen when AddButton clicked
            //print(textField.text)
            
            self.itemArray.append(textField.text ?? "NewItem")
            // use a Default string in case the of an Empty String
            
            
            
            //save updated array to defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            
            //Update/reload Data
            self.tableView.reloadData()
        }
        
        //add textField to alert
        
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create New Item"
            textField = alerttextField
            
        }
        
        
        
        //add alert
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
        
    }
    
    
    
    
    

}


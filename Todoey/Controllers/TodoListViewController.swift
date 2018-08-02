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
    var itemArray = [Item]()
    
    
    //var itemArray = ["Find Mike","Find Holand"]

    //var itemArray : Dictionary = [String:Bool]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        
        
        
        //set the array so appear as a defaultUser BindingOptional, dont crash the app
        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
        
        
    }

    
    //MARK: - Tableview DS Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        cell.textLabel?.text = item.title
        
        
        //REFACTOR --------
        //TERNARY
        //value = condition ? valueIfTrue : valueIfFalse
        //cell.accessoryType = item.done == true ? .checkmark : .none
        cell.accessoryType = item.done ? .checkmark : .none

//        if item.done == true{
//            cell.accessoryType = .checkmark
//
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    //-------------
    
    //MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        
        
        //REFACTOR
        //Reverso wat is use to be
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false{
//           itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        
        
        tableView.reloadData()
        //the other TableView Methods update
        //Force to call data sorce
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        //desselect when not pressed
        
        
    }
    
    //MARK: - Addnew Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Wat happen when AddButton clicked
            //print(textField.text)
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            //self.itemArray.append(textField.text ?? "NewItem")
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


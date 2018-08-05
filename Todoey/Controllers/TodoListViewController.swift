//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Pedro Carmezim on 01/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //let defaults = UserDefaults.standard
    
    //NSCODER
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    var itemArray = [Item]()
    
    
    //var itemArray = ["Find Mike","Find Holand"]

    //var itemArray : Dictionary = [String:Bool]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSCODER Create a path to the folder
        //Goes to GLOBAL CONST
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        print(dataFilePath)
        //Prints the filePath
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        
        //NSCODE - Load the items.plist
        loadItems()
        
        
        
        //set the array so appear as a defaultUser BindingOptional, dont crash the app
//        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
//
        
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
        
        
        
        //NSCODER - Usit to change de done state on .plist
        
//        let encoder = PropertyListEncoder()
//
//        do{
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
//        }catch{
//            print("SelfEncoding error\(error)")
//        }
//
//        tableView.reloadData()
        //the other TableView Methods update
        //Force to call data sorce
        
        //NSCODER Just Call
        saveItems()
        
        
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
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //NSCODER
//            let encoder = PropertyListEncoder()
//
//
//            do{
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            }catch{
//                print("SelfEncoding error\(error)")
//            }
            
            
            //Update/reload Data
//            self.tableView.reloadData()
            
            
            //JustCall
            self.saveItems()
            
            
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
    
    
    //Create a Save data Method
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("SelfEncoding error\(error)")
        }
        
        //Update/reload Data
        tableView.reloadData()
    }
    
    
    //NSCODE - Load the items.plist function
    
    func loadItems(){
        //Using optional binding
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)

            }catch{
                print("Error decoding data \(error)")
            }
        }
        
    }
    
    
    

}


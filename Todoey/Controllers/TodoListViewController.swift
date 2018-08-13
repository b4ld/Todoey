//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Pedro Carmezim on 01/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
    //let defaults = UserDefaults.standard
    
    //NSCODER
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //COREDATA
    //Accesses the Appdelegate context container
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //REALM
    let realm = try! Realm()
    var todoItems:Results<Item>?
    
    var selectedCategory:Category?{
        //in here - happens as soon as this var is set with a value
        didSet{
            loadItems()
        }
    }
    
    
    //var itemArray = ["Find Mike","Find Holand"]

    //var itemArray : Dictionary = [String:Bool]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //CODEDATA - File path where the data is located
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

        //loadItems()
        //here is called with default value

        //set the array so appear as a defaultUser BindingOptional, dont crash the app
//        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
//
        
    }

    
    //MARK: - Tableview DS Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No Items to Show"
        }
        
        //REFACTOR --------
        
        //TERNARY
        //value = condition ? valueIfTrue : valueIfFalse
        //cell.accessoryType = item.done == true ? .checkmark : .none
    
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
       //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
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
        //saveItems()
    
        //COREDATA - DELETE
        //CALL delete first -
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        
        
        //REALM
        //UPDATE the cell
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
                
            }catch{
                print("Could not update when seleted row\(error)")
            }
           
        }
        
        //DELETE
        
//        if let item = todoItems?[indexPath.row]{
//            do{
//                try realm.write {
//                      realm.delete(object: item)  <----------------
//                }
//
//            }catch{
//                print("Could not update when seleted row\(error)")
//            }
//
//        }
        
        
        tableView.reloadData()
      
        //saveItems()
        
        
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
            
            //COREDATA
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            //set atribute - parentCategory
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)
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
            
            
            
            //REALM---
            if let currentCategory = self.selectedCategory{
                
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    
                    //append to the current category
                    currentCategory.items.append(newItem)
                }
                }catch{
                    print("Content Not Saved \(error)")
                }
            }

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
    
    
    //Create a Save data Method
        //No need
    
    
    
    
    //REALM
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
    
    
    //External Parameter
    //= using a default values if the functions dosent have any input
    
//    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
//
//            //filter from categories - new querie
//            let categoryPredicate = NSPredicate(format: "parenteCategory.name MATCHES %@", selectedCategory!.name!)
//
//
//
//        //optional Binding
//        //making sure thas not nil
//        if let additionalPredicate = predicate  {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//
//        }else{
//            request.predicate = categoryPredicate
//        }
////            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
////
////            request.predicate = compoundPredicate
//
//
//            //Allwys specify the tipo of the request
//            do{
//                itemArray = try context.fetch(request)
//            }catch{
//                print("error fetching content \(error)")
//            }
//            tableView.reloadData()
//        }
//
    
    
    
    //NSCODE - Load the items.plist function
//    func loadItems(){
//        //Using optional binding
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//
//            }catch{
//                print("Error decoding data \(error)")
//            }
//        }
//
//    }
    
    
   

}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        searchBar.resignFirstResponder()
        tableView.reloadData()
        }
    
   
    
    
    //COREDATA
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
//        //rquest contains wat it in the searchBar
//
//        //Sort the results by title ascending
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request, predicate: predicate)



  
    //when blank searchBar, show all the entries
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            //make diferent threads
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                 //no longer selected, press "X" and desselect and keyboard goes away

            }

        }
    }

}












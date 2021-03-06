//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Pedro Carmezim on 01/08/18.
//  Copyright © 2018 Pedro Carmezim. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    

    @IBOutlet weak var searchB: UISearchBar!
    
    let realm = try! Realm()
    var todoItems:Results<Item>?
    var selectedCategory:Category?{
        //in here - happens as soon as this var is set with a value
        didSet{
            loadItems()
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //filePath
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none

        
    }

    override func viewWillAppear(_ animated: Bool) {
        //appear before view but after view is implemented in the navigations contoller
        
        
        title = selectedCategory?.name

        guard let colourHex = selectedCategory?.colour else { fatalError("ColourHex Value nil")}
        
        
        updateNavBar(withHexCode: colourHex)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Just before VC is destroyd


        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - NavBar setup code
    
    func updateNavBar(withHexCode colourHexCode:String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not Exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError("navBarCoulor nil")}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchB.barTintColor = navBarColour
        
    }
    
    //MARK: - Tableview DS Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                
                cell.backgroundColor = colour
                
                //Caontrast label
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
            
            
            
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No Items to Show"
        }
        
        //TERNARY
        //value = condition ? valueIfTrue : valueIfFalse
       
        
        return cell
    }
    
    //MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
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
    

        
        tableView.reloadData()
        
         //desselect when not pressed
        tableView.deselectRow(at: indexPath, animated: true)
       
        
        
    }
    
    //MARK: - Addnew Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        //Wat happen when AddButton clicked
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        

            //REALM---
            if let currentCategory = self.selectedCategory{
                
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    
                    //new typeDate Prop
                    newItem.dateCreated = Date()
                    
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
    
    //REALM
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
//DELETE from Swipe´

//override func updateModel(at: IndexPath)

override func updateModel(at indexPath: IndexPath) {
    
    
    if let item = todoItems?[indexPath.row]{
        do{
            try realm.write {
                realm.delete(item)
            }
            
        }catch{
            print("Could not update when selected row\(error)")
        }
        
    }
}

}






extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    //by title
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
    //By date
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        
        searchBar.resignFirstResponder()
        tableView.reloadData()
        }

  
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











